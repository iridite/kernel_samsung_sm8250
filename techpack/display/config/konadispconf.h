/* SPDX-License-Identifier: GPL-2.0-only */
/*
 * Copyright (c) 2019, The Linux Foundation. All rights reserved.
 */

#define CONFIG_DRM_MSM 1
#define CONFIG_DRM_MSM_SDE 1
#define CONFIG_SYNC_FILE 1
#define CONFIG_DRM_MSM_DSI 1
/* DisplayPort disabled on gts7xlwifi: USB-C DP is unused, and its driver's
 * secdp_event/dp_hdcp2p2/hdcp_2x kthreads wedge in D-state every boot (load ~3,
 * stalls fork). DP is separate from the DSI panel + SDE. Mirrors bengaldisp (DP=n). */
#define CONFIG_DSI_PARSER 1
#define CONFIG_DRM_SDE_WB 1
#define CONFIG_DRM_MSM_REGISTER_LOGGING 1
#define CONFIG_DRM_SDE_EVTLOG_DEBUG 1
#define CONFIG_QCOM_MDSS_PLL 1
#define CONFIG_MSM_SDE_ROTATOR 1
#define CONFIG_MSM_SDE_ROTATOR_EVTLOG_DEBUG 1
#define CONFIG_DRM_SDE_RSC 1
