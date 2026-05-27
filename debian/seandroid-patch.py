#!/usr/bin/env python3
"""
Append the literal 16-byte ASCII string `SEANDROIDENFORCE` to the kernel
section of an Android boot.img header v2, then rebuild the file so the
header's kernel_size reflects the new length. Samsung's ABL on Galaxy
Tab S7+ (and several other sm8250 Samsungs) silently rejects unsigned
boot.imgs that don't carry this marker.

Usage: seandroid-patch.py <boot.img>

Modifies <boot.img> in place. Idempotent — if the trailer is already
present at the end of the kernel section, it's a no-op.
"""
import struct
import sys
import os

MARKER = b"SEANDROIDENFORCE"  # 16 bytes


def pad(n, p):
    return ((n + p - 1) // p) * p


def main(path):
    with open(path, "rb") as f:
        d = f.read()
    if d[:8] != b"ANDROID!":
        raise SystemExit(f"{path}: not an Android boot.img (magic mismatch)")
    ks = struct.unpack("<I", d[8:12])[0]
    rs = struct.unpack("<I", d[16:20])[0]
    ss = struct.unpack("<I", d[24:28])[0]
    ps = struct.unpack("<I", d[36:40])[0]
    hv = struct.unpack("<I", d[40:44])[0]
    if hv != 2:
        # Only handling v2 (what Droidian's snippet produces today)
        raise SystemExit(f"{path}: header_version={hv}, only v2 supported")
    rds = struct.unpack("<I", d[1632:1636])[0]
    dts = struct.unpack("<I", d[1648:1652])[0]

    # Extract sections at their canonical page-aligned offsets
    off = ps
    kernel = d[off : off + ks]
    off = pad(off + ks, ps)
    ramdisk = d[off : off + rs]
    off = pad(off + rs, ps)
    second = d[off : off + ss]
    off = pad(off + ss, ps)
    recovery_dtbo = d[off : off + rds]
    off = pad(off + rds, ps)
    dtb = d[off : off + dts]

    # Idempotent check
    if kernel.endswith(MARKER):
        print(f"  already patched: {path}")
        return

    # Patch the kernel
    new_kernel = kernel + MARKER
    new_ks = len(new_kernel)

    # Reassemble: write header with updated kernel_size + padded sections.
    # Header is 4096 bytes (one page) for header_version 2.
    header = bytearray(d[: ps])
    struct.pack_into("<I", header, 8, new_ks)  # kernel_size at offset 8

    body = bytes(header)
    body += new_kernel.ljust(pad(new_ks, ps), b"\x00")
    body += ramdisk.ljust(pad(rs, ps), b"\x00") if rs > 0 else b""
    body += second.ljust(pad(ss, ps), b"\x00") if ss > 0 else b""
    body += recovery_dtbo.ljust(pad(rds, ps), b"\x00") if rds > 0 else b""
    body += dtb.ljust(pad(dts, ps), b"\x00") if dts > 0 else b""

    tmp = path + ".seandroid.tmp"
    with open(tmp, "wb") as f:
        f.write(body)
    os.replace(tmp, path)
    print(
        f"  patched: {path}  kernel {ks} -> {new_ks} bytes  total {len(d)} -> {len(body)} bytes"
    )


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    main(sys.argv[1])
