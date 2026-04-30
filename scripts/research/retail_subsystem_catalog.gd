class_name RetailSubsystemCatalog
extends RefCounted

## Higher-level RE layer that groups saved/named retail v1.29 functions into
## actionable subsystems. This sits on top of the function/command/helper
## catalogs and preserves the key named call edges recovered from Ghidra.

const FUNCTION_CATALOG_SCRIPT = preload("res://scripts/research/retail_function_catalog.gd")
const COMMAND_CATALOG_SCRIPT = preload("res://scripts/research/retail_command_catalog.gd")
const HELPER_CATALOG_SCRIPT = preload("res://scripts/research/retail_helper_catalog.gd")

const SUBSYSTEMS := {
	"combat-local-control": {
		"title": "Combat Local Control",
		"summary": "Retail local movement, throttle, jump-input, and HUD/control-loop cluster.",
		"implementation_status": "partial-analog",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
			"res://scripts/ui/combat_radar.gd",
		],
		"research_refs": [
			"RESEARCH.md:3592-3608",
			"RESEARCH.md:3621-3629",
			"RESEARCH.md:6114-6116",
		],
		"function_names": [
			"Combat_MainLoop_v129",
			"Combat_TickLocalActorControlLoop_v129",
			"Combat_UpdateUpperBodyAimCueAudio_v129",
			"Combat_ProcessMouseThrottleZoneInput_v129",
			"Combat_ProcessLocalMovementAndJumpInput_v129",
			"Combat_ProcessChassisTurnInput_v129",
			"Combat_ProcessMouseChassisTurnInput_v129",
			"Combat_ComputeMouseTurnAxisPercent_v129",
			"Combat_ComputeActorDistance_v129",
			"Combat_ApplyChassisTurnInputRate_v129",
			"Combat_ComputeActorForwardSpeedComponent_v129",
			"Combat_ProcessUpperBodyAimInput_v129",
			"Combat_RecenterUpperBodyAimOffsets_v129",
			"Combat_ProcessMouseUpperBodyAimInput_v129",
			"Combat_ProcessMouseUpperBodyAimZones_v129",
			"Combat_GetMouseControlZoneConfig_v129",
			"Combat_ApplyTorsoYawInputRate_v129",
			"Combat_ApplyUpperBodyPitchInputRate_v129",
			"Combat_AccumulateTorsoYawOffset_v129",
			"Combat_AccumulateUpperBodyPitchOffset_v129",
			"Combat_JumpJetInputTick_v129",
			"Combat_UpdateLocalThrottleTarget_v129",
			"Combat_UpdateLocalThrottleFeedbackAudio_v129",
			"Combat_PlayAudioCue_v129",
			"Combat_PlayImpactCue_v129",
			"Combat_PlayCollapseImpactCue_v129",
			"Combat_StopAudioCue_v129",
			"Combat_IsAudioCuePlaying_v129",
			"Combat_SetAudioCueVolume_v129",
			"Combat_SetAudioCuePitch_v129",
			"Combat_UpdateLocalHeatAccumulator_v129",
			"Combat_UpdateHeatShutdownState_v129",
			"Combat_UpdateJumpFuelReserve_v129",
			"Combat_ApplyLocalMovementForces_v129",
			"Combat_DampenLocalMotionState_v129",
			"Combat_ClearExpiredWeaponSlotIndicators_v129",
			"Combat_UpdateWeaponRangeIndicators_v129",
			"Combat_DrawLocalAirborneHudReadout_v129",
			"Combat_UpdateLocalMovementHudAndAnimation_v129",
			"Combat_IntegrateActorMotion_v129",
			"Combat_ResolveLandingOrGroundContact_v129",
			"Combat_ProcessLocalMechContact_v129",
			"Combat_IsActorRecoverableSupportIntact_v129",
		],
		"edges": [
			{
				"from": "Combat_TickLocalActorControlLoop_v129",
				"to": "Combat_ProcessLocalMovementAndJumpInput_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLocalActorControlLoop_v129",
				"to": "Combat_UpdateLocalThrottleTarget_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLocalActorControlLoop_v129",
				"to": "Combat_UpdateLocalThrottleFeedbackAudio_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateWeaponRangeIndicators_v129",
				"to": "Combat_ComputeActorDistance_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_MainLoop_v129",
				"to": "Combat_UpdateUpperBodyAimCueAudio_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_MainLoop_v129",
				"to": "Combat_ProcessMouseThrottleZoneInput_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessMouseThrottleZoneInput_v129",
				"to": "Combat_GetMouseControlZoneConfig_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessMouseThrottleZoneInput_v129",
				"to": "Combat_UpdateLocalThrottleTarget_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateLocalThrottleTarget_v129",
				"to": "Combat_UpdateLocalThrottleFeedbackAudio_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateUpperBodyAimCueAudio_v129",
				"to": "Combat_IsAudioCuePlaying_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateUpperBodyAimCueAudio_v129",
				"to": "Combat_PlayAudioCue_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateUpperBodyAimCueAudio_v129",
				"to": "Combat_StopAudioCue_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateUpperBodyAimCueAudio_v129",
				"to": "Combat_SetAudioCueVolume_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateUpperBodyAimCueAudio_v129",
				"to": "Combat_SetAudioCuePitch_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ApplyDamagePairOrQueueEffect_v129",
				"to": "Combat_PlayImpactCue_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_Cmd69_ImpactEffectAtCoord_v129",
				"to": "Combat_PlayImpactCue_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ResolveLandingOrGroundContact_v129",
				"to": "Combat_PlayCollapseImpactCue_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_Cmd70_ActorAnimState_v129",
				"to": "Combat_PlayCollapseImpactCue_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessLocalMovementAndJumpInput_v129",
				"to": "Combat_ProcessChassisTurnInput_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessChassisTurnInput_v129",
				"to": "Combat_ProcessMouseChassisTurnInput_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessMouseChassisTurnInput_v129",
				"to": "Combat_ComputeMouseTurnAxisPercent_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessChassisTurnInput_v129",
				"to": "Combat_ApplyChassisTurnInputRate_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessMouseChassisTurnInput_v129",
				"to": "Combat_ApplyChassisTurnInputRate_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessLocalMovementAndJumpInput_v129",
				"to": "Combat_ProcessUpperBodyAimInput_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessLocalMovementAndJumpInput_v129",
				"to": "Combat_JumpJetInputTick_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessUpperBodyAimInput_v129",
				"to": "Combat_RecenterUpperBodyAimOffsets_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessUpperBodyAimInput_v129",
				"to": "Combat_ProcessMouseUpperBodyAimInput_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessUpperBodyAimInput_v129",
				"to": "Combat_ProcessMouseUpperBodyAimZones_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessMouseUpperBodyAimZones_v129",
				"to": "Combat_GetMouseControlZoneConfig_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessUpperBodyAimInput_v129",
				"to": "Combat_ApplyTorsoYawInputRate_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessUpperBodyAimInput_v129",
				"to": "Combat_ApplyUpperBodyPitchInputRate_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ApplyLocalMovementForces_v129",
				"to": "Combat_ComputeActorForwardSpeedComponent_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessMouseUpperBodyAimZones_v129",
				"to": "Combat_ApplyTorsoYawInputRate_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessMouseUpperBodyAimZones_v129",
				"to": "Combat_ApplyUpperBodyPitchInputRate_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessMouseUpperBodyAimInput_v129",
				"to": "Combat_AccumulateTorsoYawOffset_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ProcessMouseUpperBodyAimInput_v129",
				"to": "Combat_AccumulateUpperBodyPitchOffset_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ComputeMouseTurnAxisPercent_v129",
				"to": "Combat_GetMouseControlZoneConfig_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateLocalMovementHudAndAnimation_v129",
				"to": "Combat_ComputeActorForwardSpeedComponent_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateLocalThrottleFeedbackAudio_v129",
				"to": "Combat_ComputeActorForwardSpeedComponent_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateLocalThrottleFeedbackAudio_v129",
				"to": "Combat_PlayAudioCue_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateLocalThrottleFeedbackAudio_v129",
				"to": "Combat_SetAudioCuePitch_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLocalActorControlLoop_v129",
				"to": "Combat_UpdateLocalHeatAccumulator_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLocalActorControlLoop_v129",
				"to": "Combat_UpdateJumpFuelReserve_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLocalActorControlLoop_v129",
				"to": "Combat_DampenLocalMotionState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLocalActorControlLoop_v129",
				"to": "Combat_ApplyLocalMovementForces_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLocalActorControlLoop_v129",
				"to": "Combat_ClearExpiredWeaponSlotIndicators_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLocalActorControlLoop_v129",
				"to": "Combat_UpdateWeaponRangeIndicators_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLocalActorControlLoop_v129",
				"to": "Combat_DrawLocalAirborneHudReadout_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateLocalHeatAccumulator_v129",
				"to": "Combat_UpdateHeatShutdownState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateHeatShutdownState_v129",
				"to": "Combat_UpdateLocalMovementHudAndAnimation_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_JumpJetInputTick_v129",
				"to": "Combat_ComputeMouseTurnAxisPercent_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_JumpJetInputTick_v129",
				"to": "Combat_SendCmd12Action_v129",
				"kind": "research-linked",
			},
		],
	},
	"combat-animation-fall": {
		"title": "Combat Animation and Fall State",
		"summary": "Retail actor animation-state, fall-down, recovery-block, and pose-building cluster.",
		"implementation_status": "partial-analog",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": [
			"RESEARCH.md:3588-3595",
			"RESEARCH.md:2109-2115",
		],
		"function_names": [
			"Combat_Cmd70_ActorAnimState_v129",
			"Combat_SetActorAnimationState_v129",
			"Combat_StartFallDownAnim_SetRecoveryBlock_v129",
			"Combat_AnimCallback_ClearActorRecoveryBlock_v129",
			"Combat_ArmDeferredCollapseWhileAirborne_v129",
			"Combat_FindAnimationStateDefinitionById_v129",
			"Combat_BuildActorAnimationPose_v129",
			"Combat_BuildAnimationNodePoseRecursive_v129",
			"Combat_UpdateAnimationControllerProgress_v129",
			"Combat_GetAnimationNodeByStateTag_v129",
			"Combat_AdvanceAnimationControllerState_v129",
		],
		"edges": [
			{
				"from": "Combat_Cmd70_ActorAnimState_v129",
				"to": "Combat_SetActorAnimationState_v129",
				"kind": "research-linked",
			},
			{
				"from": "Combat_SetActorAnimationState_v129",
				"to": "Combat_StartFallDownAnim_SetRecoveryBlock_v129",
				"kind": "research-linked",
			},
			{
				"from": "Combat_StartFallDownAnim_SetRecoveryBlock_v129",
				"to": "Combat_AnimCallback_ClearActorRecoveryBlock_v129",
				"kind": "research-linked",
			},
			{
				"from": "Combat_StartFallDownAnim_SetRecoveryBlock_v129",
				"to": "Combat_ArmDeferredCollapseWhileAirborne_v129",
				"kind": "research-linked",
			},
		],
	},
	"combat-lasr-sound": {
		"title": "Combat LASR Sound",
		"summary": "Retail LASR sound state machine that auto-selects, applies, and tears down combat alert sound profiles.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/audio/audio_manager.gd",
		],
		"function_names": [
			"Shell_RunCombatStateTick_v129",
			"Combat_AutoSelectLasrSoundState_v129",
			"Combat_AreActorsWithinAnyWeaponRange_v129",
			"Combat_AdjustLasrProfileTempo_v129",
			"Combat_AdjustLasrSequenceTempo_v129",
			"Combat_CompareActorRelativeEffectiveness_v129",
			"Combat_ComputeActorEffectivenessScore_v129",
			"Combat_EnsureLasrSoundInitialized_v129",
			"Combat_EnsureLasrMidiOutputOpen_v129",
			"Combat_FadeOutLasrProfileVolume_v129",
			"Combat_GetLasrSoundState_v129",
			"Combat_GetLasrSequenceStatus_v129",
			"Combat_InitLasrSequenceHandle_v129",
			"Combat_LoadLasrSequenceData_v129",
			"Combat_LoadLasrSequenceProfiles_v129",
			"Combat_OpenLasrProfileSequences_v129",
			"Combat_ReleaseLasrSequenceHandle_v129",
			"Combat_SetLasrProfileVolume_v129",
			"Combat_SetLasrSequenceVolume_v129",
			"Combat_SetLasrSoundState_v129",
			"Combat_StartLasrSequence_v129",
			"Combat_StepLasrRelativeEffectivenessState_v129",
			"Combat_StepLasrProfileVolumeTowardTarget_v129",
			"Combat_StopLasrProfileSequences_v129",
			"Combat_StopLasrSound_v129",
			"Combat_StopLasrSequence_v129",
			"Combat_TickLasrSoundState_v129",
			"Combat_ResetLasrSoundState_v129",
			"Combat_EndLasrSequence_v129",
		],
		"edges": [
			{
				"from": "Shell_RunCombatStateTick_v129",
				"to": "Combat_AutoSelectLasrSoundState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_AutoSelectLasrSoundState_v129",
				"to": "Combat_GetLasrSoundState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_AutoSelectLasrSoundState_v129",
				"to": "Combat_AreActorsWithinAnyWeaponRange_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_AutoSelectLasrSoundState_v129",
				"to": "Combat_CompareActorRelativeEffectiveness_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_AutoSelectLasrSoundState_v129",
				"to": "Combat_StepLasrRelativeEffectivenessState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_CompareActorRelativeEffectiveness_v129",
				"to": "Combat_ComputeActorEffectivenessScore_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_EnsureLasrSoundInitialized_v129",
				"to": "Combat_EnsureLasrMidiOutputOpen_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_EnsureLasrSoundInitialized_v129",
				"to": "Combat_LoadLasrSequenceProfiles_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_EnsureLasrSoundInitialized_v129",
				"to": "Combat_ResetLasrSoundState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_AutoSelectLasrSoundState_v129",
				"to": "Combat_SetLasrSoundState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_StopLasrSound_v129",
				"to": "Combat_StopLasrProfileSequences_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_StopLasrSound_v129",
				"to": "Combat_ResetLasrSoundState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLasrSoundState_v129",
				"to": "Combat_StepLasrProfileVolumeTowardTarget_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLasrSoundState_v129",
				"to": "Combat_FadeOutLasrProfileVolume_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLasrSoundState_v129",
				"to": "Combat_OpenLasrProfileSequences_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLasrSoundState_v129",
				"to": "Combat_StartLasrSequence_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLasrSoundState_v129",
				"to": "Combat_GetLasrSequenceStatus_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_TickLasrSoundState_v129",
				"to": "Combat_EndLasrSequence_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_StopLasrProfileSequences_v129",
				"to": "Combat_StopLasrSequence_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_StopLasrProfileSequences_v129",
				"to": "Combat_ReleaseLasrSequenceHandle_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePostVersionBannerLine_v129",
				"to": "Combat_StopLasrSound_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ServiceNetworkStateLoop_v129",
				"to": "Combat_TickLasrSoundState_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"combat-voice-transmission": {
		"title": "Combat Voice Transmission",
		"summary": "Retail combat voice-transmission HUD redraw, roster/history views, and active speaker status overlay cluster.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
		"function_names": [
			"Combat_MainLoop_v129",
			"Combat_Cmd59_ConfigureVoiceTransmission_v129",
			"Combat_Cmd60_UpdateActorVoiceTransmissionState_v129",
			"Combat_Cmd61_SetVoiceTransmissionTuneToChannelId_v129",
			"Combat_AppendVoiceTransmissionHistoryEntry_v129",
			"Combat_HandleVoiceTransmissionInput_v129",
			"Combat_RedrawVoiceTransmissionHud_v129",
			"Combat_RedrawVoiceTransmissionHudBlank_v129",
			"Combat_RedrawVoiceTransmissionHudHistory_v129",
			"Combat_DrawVoiceTransmissionHudLabel_v129",
			"Combat_DrawVoiceTransmissionStatusHud_v129",
			"Combat_RedrawVoiceTransmissionHudRoster_v129",
			"Combat_SendVoiceTransmissionText_v129",
		],
		"edges": [
			{
				"from": "Combat_Cmd60_UpdateActorVoiceTransmissionState_v129",
				"to": "Combat_RedrawVoiceTransmissionHud_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_Cmd61_SetVoiceTransmissionTuneToChannelId_v129",
				"to": "Combat_RedrawVoiceTransmissionHud_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_Cmd74_DisplayStatusMessage_v129",
				"to": "Combat_AppendVoiceTransmissionHistoryEntry_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_AppendVoiceTransmissionHistoryEntry_v129",
				"to": "Combat_RedrawVoiceTransmissionHud_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_HandleVoiceTransmissionInput_v129",
				"to": "Combat_SendVoiceTransmissionText_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_HandleVoiceTransmissionInput_v129",
				"to": "Combat_AppendVoiceTransmissionHistoryEntry_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RedrawVoiceTransmissionHud_v129",
				"to": "Combat_RedrawVoiceTransmissionHudBlank_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RedrawVoiceTransmissionHud_v129",
				"to": "Combat_RedrawVoiceTransmissionHudHistory_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RedrawVoiceTransmissionHud_v129",
				"to": "Combat_RedrawVoiceTransmissionHudRoster_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RedrawVoiceTransmissionHudHistory_v129",
				"to": "Combat_DrawVoiceTransmissionHudLabel_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RedrawVoiceTransmissionHudRoster_v129",
				"to": "Combat_DrawVoiceTransmissionHudLabel_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_DrawVoiceTransmissionStatusHud_v129",
				"to": "Combat_DrawVoiceTransmissionHudLabel_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_MainLoop_v129",
				"to": "Combat_DrawVoiceTransmissionStatusHud_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"combat-visual-bootstrap": {
		"title": "Combat Visual Bootstrap",
		"summary": "Retail combat startup path that refreshes HUD fonts, loads COMBAT.DAT bitmap tables, and seeds baseline visual state before steady-state rendering.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
		"function_names": [
			"Combat_MainLoop_v129",
			"Combat_InitializeVisualResourcesAndHudState_v129",
			"Combat_LoadVisualResourceTables_v129",
			"ResourceArchive_OpenTaggedArchive_v129",
			"ResourceArchive_SeekTaggedEntry_v129",
			"Frame_LoadBitmapFromFile_v129",
			"Frame_FreeBitmap_v129",
			"Frame_BlitBitmapPixels_v129",
		],
		"edges": [
			{
				"from": "Combat_MainLoop_v129",
				"to": "Combat_InitializeVisualResourcesAndHudState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_InitializeVisualResourcesAndHudState_v129",
				"to": "Combat_LoadVisualResourceTables_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_LoadVisualResourceTables_v129",
				"to": "ResourceArchive_OpenTaggedArchive_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_LoadVisualResourceTables_v129",
				"to": "ResourceArchive_SeekTaggedEntry_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_LoadVisualResourceTables_v129",
				"to": "Frame_LoadBitmapFromFile_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_LoadVisualResourceTables_v129",
				"to": "Frame_BlitBitmapPixels_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_LoadVisualResourceTables_v129",
				"to": "Frame_FreeBitmap_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"shell-picture-bootstrap": {
		"title": "Shell Picture Bootstrap",
		"summary": "Retail title/credits presentation plus the MW_MPICS, HUNITS, and UNITS picture-table bootstrap used by world-shell and result-scene surfaces.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
		"function_names": [
			"Combat_Cmd63_ResultSceneInit_v129",
			"Shell_EnterDropScene_v129",
			"Shell_InitializeFrontendResourcesAndAudio_v129",
			"Frame_LoadMwPictureArchivesAndTables_v129",
			"Frame_LoadWorldShellBitmapTables_v129",
			"Frame_FreeWorldShellBitmapTables_v129",
			"Frame_LoadUnitBitmapByTag_v129",
			"Frame_ResolveInlineBitmapTag_v129",
			"Frame_ShowCenteredArchiveBitmap_v129",
			"Shell_ShowTitleAndCreditsSequence_v129",
			"ResourceArchive_OpenTaggedArchive_v129",
			"ResourceArchive_SeekTaggedEntry_v129",
			"Frame_LoadBitmapFromFile_v129",
			"Frame_FreeBitmap_v129",
		],
		"edges": [
			{
				"from": "Combat_Cmd63_ResultSceneInit_v129",
				"to": "Frame_ShowCenteredArchiveBitmap_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_Cmd63_ResultSceneInit_v129",
				"to": "Frame_LoadMwPictureArchivesAndTables_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_InitializeFrontendResourcesAndAudio_v129",
				"to": "Frame_LoadMwPictureArchivesAndTables_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadMwPictureArchivesAndTables_v129",
				"to": "Frame_LoadWorldShellBitmapTables_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_Cmd63_ResultSceneInit_v129",
				"to": "Frame_FreeWorldShellBitmapTables_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadMwPictureArchivesAndTables_v129",
				"to": "ResourceArchive_OpenTaggedArchive_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadMwPictureArchivesAndTables_v129",
				"to": "ResourceArchive_SeekTaggedEntry_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadMwPictureArchivesAndTables_v129",
				"to": "Frame_LoadBitmapFromFile_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadWorldShellBitmapTables_v129",
				"to": "ResourceArchive_SeekTaggedEntry_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadWorldShellBitmapTables_v129",
				"to": "Frame_LoadBitmapFromFile_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_ResolveInlineBitmapTag_v129",
				"to": "Frame_LoadUnitBitmapByTag_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_EnterDropScene_v129",
				"to": "World_ClearWorldUiChildren_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_EnterDropScene_v129",
				"to": "Frame_ShowCenteredArchiveBitmap_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ShowTitleAndCreditsSequence_v129",
				"to": "ResourceArchive_OpenTaggedArchive_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ShowTitleAndCreditsSequence_v129",
				"to": "ResourceArchive_SeekTaggedEntry_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ShowTitleAndCreditsSequence_v129",
				"to": "Frame_LoadBitmapFromFile_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ShowTitleAndCreditsSequence_v129",
				"to": "Frame_DrawBitmapResourceAt_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ShowTitleAndCreditsSequence_v129",
				"to": "Frame_FreeBitmap_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"shell-state-dispatch": {
		"title": "Shell State Dispatch",
		"summary": "Retail frontend entry, network frame polling, ESC command validation/dispatch, and state-transition tick path for the shell/world/combat/drop flows.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scripts/net/server_bridge.gd",
			"res://scripts/audio/audio_manager.gd",
		],
		"function_names": [
			"Shell_RunFrontendMain_v129",
			"Shell_ServiceNetworkStateLoop_v129",
			"Shell_RunWorldStateTick_v129",
			"Shell_RunCombatStateTick_v129",
			"Shell_HandleReceivedMessage_v129",
			"Shell_ResetFrontendTransientState_v129",
			"Shell_ResetHeartbeatState_v129",
			"Shell_SelectInboundCommandTable_v129",
			"Shell_ClearNumLockToggleState_v129",
			"Shell_RestoreMainWindowIfAuxiliaryClosed_v129",
			"Shell_ClearStatusMarqueeBuffer_v129",
			"Shell_AppendStatusMarqueeText_v129",
			"Shell_SendHeartbeat_v129",
			"Shell_EncodeRpsPreambleStateByte_v129",
			"Shell_HandleRpsPreambleStateByte_v129",
			"Shell_RespondToFrq_v129",
			"Shell_TickScrollingStatusMarquee_v129",
			"World_TickAnimatedShellBitmaps_v129",
			"Shell_HandlePostVersionBannerLine_v129",
			"Shell_HandlePreVersionBannerLine_v129",
			"Shell_ClassifyBannerLine_v129",
			"Shell_AppendEscDelimitedStreamChunk_v129",
			"Shell_ValidateAndDispatchEscCommandBuffer_v129",
			"Shell_VerifyEscCommandChecksum_v129",
			"Shell_DispatchValidatedCommandBuffer_v129",
			"Shell_AppendOutboundCommandOpcode_v129",
			"Shell_FlushOutboundCommandBuffer_v129",
			"Shell_SendCloseCommandsToVisibleThreadWindows_v129",
			"Shell_InitializeFrontendResourcesAndAudio_v129",
			"Shell_EnterDropScene_v129",
			"Combat_Cmd63_ResultSceneInit_v129",
		],
		"edges": [
			{
				"from": "Shell_RunFrontendMain_v129",
				"to": "Shell_InitializeFrontendResourcesAndAudio_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_InitializeFrontendResourcesAndAudio_v129",
				"to": "Shell_ResetFrontendTransientState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_RunFrontendMain_v129",
				"to": "Shell_ServiceNetworkStateLoop_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ServiceNetworkStateLoop_v129",
				"to": "Shell_HandlePostVersionBannerLine_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ServiceNetworkStateLoop_v129",
				"to": "Shell_RunWorldStateTick_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ServiceNetworkStateLoop_v129",
				"to": "Shell_RunCombatStateTick_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePostVersionBannerLine_v129",
				"to": "Shell_SelectInboundCommandTable_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePreVersionBannerLine_v129",
				"to": "Shell_SelectInboundCommandTable_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_DispatchValidatedCommandBuffer_v129",
				"to": "Shell_HandleRpsPreambleStateByte_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandleRpsPreambleStateByte_v129",
				"to": "Shell_EncodeRpsPreambleStateByte_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePostVersionBannerLine_v129",
				"to": "Shell_ClassifyBannerLine_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePostVersionBannerLine_v129",
				"to": "Combat_Cmd63_ResultSceneInit_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePostVersionBannerLine_v129",
				"to": "Shell_ResetHeartbeatState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePostVersionBannerLine_v129",
				"to": "Shell_EnterDropScene_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_EnterDropScene_v129",
				"to": "Shell_ResetFrontendTransientState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePostVersionBannerLine_v129",
				"to": "Shell_SendCloseCommandsToVisibleThreadWindows_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePostVersionBannerLine_v129",
				"to": "Shell_AppendEscDelimitedStreamChunk_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePostVersionBannerLine_v129",
				"to": "Shell_FlushOutboundCommandBuffer_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePreVersionBannerLine_v129",
				"to": "Shell_ClassifyBannerLine_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePreVersionBannerLine_v129",
				"to": "Shell_ResetHeartbeatState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePreVersionBannerLine_v129",
				"to": "Shell_ClearStatusMarqueeBuffer_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_HandlePreVersionBannerLine_v129",
				"to": "Shell_EnterDropScene_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_RunWorldStateTick_v129",
				"to": "Shell_ClearNumLockToggleState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_RunWorldStateTick_v129",
				"to": "Shell_RestoreMainWindowIfAuxiliaryClosed_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_RunWorldStateTick_v129",
				"to": "Shell_TickScrollingStatusMarquee_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_RunWorldStateTick_v129",
				"to": "World_TickAnimatedShellBitmaps_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_RunWorldStateTick_v129",
				"to": "Frame_CyclePaletteEntries_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_RunCombatStateTick_v129",
				"to": "Shell_ClearNumLockToggleState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_AppendEscDelimitedStreamChunk_v129",
				"to": "Shell_ValidateAndDispatchEscCommandBuffer_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ValidateAndDispatchEscCommandBuffer_v129",
				"to": "Shell_VerifyEscCommandChecksum_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ValidateAndDispatchEscCommandBuffer_v129",
				"to": "Shell_DispatchValidatedCommandBuffer_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ValidateAndDispatchEscCommandBuffer_v129",
				"to": "Shell_AppendOutboundCommandOpcode_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ValidateAndDispatchEscCommandBuffer_v129",
				"to": "Shell_FlushOutboundCommandBuffer_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"frame-protocol-codec": {
		"title": "Frame Protocol Codec",
		"summary": "Retail inbound/outbound command byte and integer codec shared by shell, world, and combat network handlers.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scripts/net/auth_client.gd",
			"res://scripts/net/world_client.gd",
			"res://scripts/net/arena_client.gd",
		],
		"function_names": [
			"Frame_DecodeArg_v129",
			"Frame_DecodeByteArg_v129",
			"Frame_DecodeType1Arg_v129",
			"Frame_DecodeStringArg_v129",
			"Frame_DecodeType1StringArg_v129",
			"Frame_DecodeStringSpanArg_v129",
			"Frame_DecodeType1StringSpanArg_v129",
			"Frame_EncodeArg_v129",
			"Frame_EncodeByteArg_v129",
			"Frame_EncodeByteCountedStringArg_v129",
			"Frame_EncodeType1Arg_v129",
			"Frame_EncodeType1StringArg_v129",
			"Shell_AppendOutboundCommandOpcode_v129",
			"Shell_FlushOutboundCommandBuffer_v129",
			"Shell_ValidateAndDispatchEscCommandBuffer_v129",
			"Shell_VerifyEscCommandChecksum_v129",
			"Shell_DispatchValidatedCommandBuffer_v129",
		],
		"edges": [
			{
				"from": "Shell_ValidateAndDispatchEscCommandBuffer_v129",
				"to": "Shell_VerifyEscCommandChecksum_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ValidateAndDispatchEscCommandBuffer_v129",
				"to": "Shell_DispatchValidatedCommandBuffer_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ValidateAndDispatchEscCommandBuffer_v129",
				"to": "Shell_AppendOutboundCommandOpcode_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ValidateAndDispatchEscCommandBuffer_v129",
				"to": "Shell_FlushOutboundCommandBuffer_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_DispatchValidatedCommandBuffer_v129",
				"to": "Frame_DecodeArg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_DispatchValidatedCommandBuffer_v129",
				"to": "Frame_DecodeByteArg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DecodeStringArg_v129",
				"to": "Frame_DecodeStringSpanArg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DecodeType1StringArg_v129",
				"to": "Frame_DecodeType1StringSpanArg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DecodeStringSpanArg_v129",
				"to": "Frame_DecodeArg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DecodeType1StringSpanArg_v129",
				"to": "Frame_DecodeArg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_EncodeType1Arg_v129",
				"to": "Frame_EncodeArg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_EncodeType1StringArg_v129",
				"to": "Frame_EncodeArg_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"combat-actor-preview": {
		"title": "Combat Actor Preview Panels",
		"summary": "Retail self/target actor preview panel renderer used by the combat main loop.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
		"function_names": [
			"Combat_MainLoop_v129",
			"Combat_BuildActorAnimationPose_v129",
			"Combat_RenderActorPreviewPanel_v129",
			"Combat_RenderModelAttachments_v129",
			"Frame_DrawGlyph_v129",
			"Frame_DrawString_v129",
			"Frame_CompositeMaskedSpanRuns_v129",
			"Frame_BlitRelativeRect_v129",
			"Frame_GetGlyphAdvance_v129",
			"Frame_MeasureGlyphRunWidth_v129",
			"Frame_MeasureStringWidth_v129",
		],
		"edges": [
			{
				"from": "Combat_MainLoop_v129",
				"to": "Combat_RenderActorPreviewPanel_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActorPreviewPanel_v129",
				"to": "Combat_BuildActorAnimationPose_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActorPreviewPanel_v129",
				"to": "Combat_RenderModelAttachments_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActorPreviewPanel_v129",
				"to": "Frame_CompositeMaskedSpanRuns_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActorPreviewPanel_v129",
				"to": "Frame_BlitRelativeRect_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActorPreviewPanel_v129",
				"to": "Frame_MeasureStringWidth_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActorPreviewPanel_v129",
				"to": "Frame_DrawString_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_MeasureStringWidth_v129",
				"to": "Frame_MeasureGlyphRunWidth_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_MeasureGlyphRunWidth_v129",
				"to": "Frame_GetGlyphAdvance_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawString_v129",
				"to": "Frame_DrawGlyph_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"frame-text-rendering": {
		"title": "Frame Rendering",
		"summary": "Retail frame-level text, line, bevel, bitmap, palette, and editable text helpers shared across combat and world UI surfaces.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
		"function_names": [
			"Frame_BlitRelativeRect_v129",
			"Frame_BlitBitmapWithTransparentKey_v129",
			"Frame_BlitBitmapPixels_v129",
			"Frame_CopyBitmapPixelsToBuffer_v129",
			"Frame_CyclePaletteEntries_v129",
			"Frame_DecodeBitmapRleData_v129",
			"Frame_GetCachedBitmapBuffer_v129",
			"Frame_LoadBitmapBufferFromArchive_v129",
			"Frame_LoadBitmapFromFile_v129",
			"Frame_LoadMwPictureArchivesAndTables_v129",
			"Frame_FreeBitmap_v129",
			"ResourceArchive_OpenTaggedArchive_v129",
			"ResourceArchive_SeekTaggedEntry_v129",
			"Frame_DrawBitmapResourceAt_v129",
			"Frame_DrawBitmapResourceTransparentAt_v129",
			"Frame_DrawLine_v129",
			"Frame_DrawLineAndPresent_v129",
			"Frame_DrawBeveledRectAndPresent_v129",
			"Frame_DrawBeveledFillBar_v129",
			"Frame_DrawFilledBoxOrBitmapDecoration_v129",
			"Frame_DrawBeveledBorderDecoration_v129",
			"Frame_DrawBeveledRect_v129",
			"Frame_DrawFilledCircleSector_v129",
			"Frame_DrawFormattedText_v129",
			"Frame_DrawGlyph_v129",
			"Frame_DrawString_v129",
			"Frame_DrawTextDecorationByIndex_v129",
			"Frame_DrawWrappedLine_v129",
			"Frame_DrawWrappedTextBlock_v129",
			"Frame_GetCurrentWrappedLineText_v129",
			"Frame_GetFontLineHeight_v129",
			"Frame_GetGlyphAdvance_v129",
			"Frame_GetPaletteEntryRgb_v129",
			"Frame_MeasureGlyphRunWidth_v129",
			"Frame_MeasureStringWidth_v129",
			"Frame_ResetTextLayoutState_v129",
			"Frame_ResetTextLayoutStateWithInsets_v129",
			"Frame_RedrawRegisteredTextDecorations_v129",
			"Frame_ResolveInlineBitmapTag_v129",
			"Frame_SetPaletteEntryRgb_v129",
			"Shell_ShowTitleAndCreditsSequence_v129",
			"Frame_ShowCenteredArchiveBitmap_v129",
			"Frame_SwapPaletteIndicesInRect_v129",
			"Frame_UpdatePaletteRange_v129",
			"Frame_UpdateTextCursorHighlight_v129",
			"Frame_WriteCharAtCursor_v129",
			"Frame_WriteCharAtLineColumn_v129",
			"Frame_ScrollTextViewportUpIfAtBottom_v129",
			"Frame_AppendWrappedInputChar_v129",
			"Frame_BackspaceWrappedInputChar_v129",
			"Frame_DrawInlineAssetRuns_v129",
			"Frame_LoadUnitBitmapByTag_v129",
			"Frame_LoadWorldShellBitmapTables_v129",
		],
		"edges": [
			{
				"from": "Frame_CyclePaletteEntries_v129",
				"to": "Frame_GetPaletteEntryRgb_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_CyclePaletteEntries_v129",
				"to": "Frame_SetPaletteEntryRgb_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_CyclePaletteEntries_v129",
				"to": "Frame_UpdatePaletteRange_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_MeasureStringWidth_v129",
				"to": "Frame_MeasureGlyphRunWidth_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_MeasureGlyphRunWidth_v129",
				"to": "Frame_GetGlyphAdvance_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawString_v129",
				"to": "Frame_DrawGlyph_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_WriteCharAtCursor_v129",
				"to": "Frame_WriteCharAtLineColumn_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_WriteCharAtLineColumn_v129",
				"to": "Frame_ScrollTextViewportUpIfAtBottom_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_WriteCharAtLineColumn_v129",
				"to": "Frame_DrawGlyph_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_WriteCharAtLineColumn_v129",
				"to": "Frame_GetGlyphAdvance_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_ResetTextLayoutState_v129",
				"to": "Frame_RedrawRegisteredTextDecorations_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_ResetTextLayoutState_v129",
				"to": "Frame_DrawBeveledRect_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_ResetTextLayoutStateWithInsets_v129",
				"to": "Frame_RedrawRegisteredTextDecorations_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_RedrawRegisteredTextDecorations_v129",
				"to": "Frame_DrawTextDecorationByIndex_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawTextDecorationByIndex_v129",
				"to": "Frame_GetFontLineHeight_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawTextDecorationByIndex_v129",
				"to": "Frame_DrawFilledBoxOrBitmapDecoration_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawTextDecorationByIndex_v129",
				"to": "Frame_DrawBeveledBorderDecoration_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawBeveledBorderDecoration_v129",
				"to": "Frame_DrawBeveledRectAndPresent_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawBeveledBorderDecoration_v129",
				"to": "Frame_DrawBeveledRect_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawTextDecorationByIndex_v129",
				"to": "Frame_DrawBitmapResourceAt_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawBitmapResourceTransparentAt_v129",
				"to": "Frame_BlitBitmapWithTransparentKey_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawBitmapResourceAt_v129",
				"to": "Frame_BlitBitmapPixels_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_BlitBitmapWithTransparentKey_v129",
				"to": "Frame_DecodeBitmapRleData_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_BlitBitmapPixels_v129",
				"to": "Frame_DecodeBitmapRleData_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_GetCachedBitmapBuffer_v129",
				"to": "Frame_LoadBitmapBufferFromArchive_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_GetCachedBitmapBuffer_v129",
				"to": "ResourceArchive_OpenTaggedArchive_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadBitmapBufferFromArchive_v129",
				"to": "Frame_CopyBitmapPixelsToBuffer_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadBitmapBufferFromArchive_v129",
				"to": "ResourceArchive_SeekTaggedEntry_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadBitmapBufferFromArchive_v129",
				"to": "Frame_LoadBitmapFromFile_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_CopyBitmapPixelsToBuffer_v129",
				"to": "Frame_DecodeBitmapRleData_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadBitmapFromFile_v129",
				"to": "Frame_FreeBitmap_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadMwPictureArchivesAndTables_v129",
				"to": "Frame_LoadWorldShellBitmapTables_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadMwPictureArchivesAndTables_v129",
				"to": "ResourceArchive_OpenTaggedArchive_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadMwPictureArchivesAndTables_v129",
				"to": "ResourceArchive_SeekTaggedEntry_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadMwPictureArchivesAndTables_v129",
				"to": "Frame_LoadBitmapFromFile_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadUnitBitmapByTag_v129",
				"to": "ResourceArchive_SeekTaggedEntry_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_LoadUnitBitmapByTag_v129",
				"to": "Frame_LoadBitmapFromFile_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawBeveledRectAndPresent_v129",
				"to": "Frame_DrawLineAndPresent_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawBeveledRect_v129",
				"to": "Frame_DrawLine_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawFormattedText_v129",
				"to": "Frame_MeasureGlyphRunWidth_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawFormattedText_v129",
				"to": "Frame_WriteCharAtCursor_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawFormattedText_v129",
				"to": "Frame_DrawBitmapResourceAt_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawFormattedText_v129",
				"to": "Frame_DrawBeveledFillBar_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawFormattedText_v129",
				"to": "Frame_DrawFilledCircleSector_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawFormattedText_v129",
				"to": "Frame_ResolveInlineBitmapTag_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawBeveledFillBar_v129",
				"to": "Frame_DrawBeveledRect_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawBeveledFillBar_v129",
				"to": "Frame_DrawLine_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawTextDecorationByIndex_v129",
				"to": "Frame_DrawString_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawInlineAssetRuns_v129",
				"to": "Frame_ResolveInlineBitmapTag_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawInlineAssetRuns_v129",
				"to": "Frame_DrawBitmapResourceAt_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_ShowCenteredArchiveBitmap_v129",
				"to": "ResourceArchive_OpenTaggedArchive_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_ShowCenteredArchiveBitmap_v129",
				"to": "ResourceArchive_SeekTaggedEntry_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_ShowCenteredArchiveBitmap_v129",
				"to": "Frame_LoadBitmapFromFile_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_ShowCenteredArchiveBitmap_v129",
				"to": "Frame_DrawBitmapResourceAt_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_ShowCenteredArchiveBitmap_v129",
				"to": "Frame_FreeBitmap_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ShowTitleAndCreditsSequence_v129",
				"to": "ResourceArchive_OpenTaggedArchive_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ShowTitleAndCreditsSequence_v129",
				"to": "ResourceArchive_SeekTaggedEntry_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ShowTitleAndCreditsSequence_v129",
				"to": "Frame_LoadBitmapFromFile_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ShowTitleAndCreditsSequence_v129",
				"to": "Frame_DrawBitmapResourceAt_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Shell_ShowTitleAndCreditsSequence_v129",
				"to": "Frame_FreeBitmap_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawWrappedLine_v129",
				"to": "Frame_WriteCharAtCursor_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawWrappedTextBlock_v129",
				"to": "Frame_DrawInlineAssetRuns_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawWrappedTextBlock_v129",
				"to": "Frame_DrawWrappedLine_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_DrawWrappedTextBlock_v129",
				"to": "Frame_MeasureStringWidth_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_AppendWrappedInputChar_v129",
				"to": "Frame_ResetTextLayoutStateWithInsets_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_AppendWrappedInputChar_v129",
				"to": "Frame_UpdateTextCursorHighlight_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_AppendWrappedInputChar_v129",
				"to": "Frame_WriteCharAtCursor_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_AppendWrappedInputChar_v129",
				"to": "Frame_DrawWrappedTextBlock_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_AppendWrappedInputChar_v129",
				"to": "Frame_GetGlyphAdvance_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_BackspaceWrappedInputChar_v129",
				"to": "Frame_ResetTextLayoutStateWithInsets_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_BackspaceWrappedInputChar_v129",
				"to": "Frame_UpdateTextCursorHighlight_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_BackspaceWrappedInputChar_v129",
				"to": "Frame_BlitRelativeRect_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_BackspaceWrappedInputChar_v129",
				"to": "Frame_DrawWrappedTextBlock_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_BackspaceWrappedInputChar_v129",
				"to": "Frame_GetGlyphAdvance_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_UpdateTextCursorHighlight_v129",
				"to": "Frame_SwapPaletteIndicesInRect_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_UpdateTextCursorHighlight_v129",
				"to": "Frame_GetCurrentWrappedLineText_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_UpdateTextCursorHighlight_v129",
				"to": "Frame_MeasureStringWidth_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Frame_UpdateTextCursorHighlight_v129",
				"to": "Frame_GetFontLineHeight_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"combat-projectile-effects": {
		"title": "Combat Projectile Effects",
		"summary": "Retail projectile/effect spawn, in-flight update, queued damage, and impact-resolution cluster.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
			"res://scripts/audio/audio_manager.gd",
		],
		"research_refs": [
			"RESEARCH.md:4139",
			"RESEARCH.md:4736-4739",
			"RESEARCH.md:4985",
			"RESEARCH.md:5111-5114",
		],
		"function_names": [
			"Combat_Cmd66_ActorDamageUpdate_v129",
			"Combat_Cmd67_LocalDamageUpdate_v129",
			"Combat_Cmd68_SpawnWeaponEffect_v129",
			"Combat_Cmd69_ImpactEffectAtCoord_v129",
			"Combat_Cmd71_ResetEffectState_v129",
			"Combat_ApplyDamagePairOrQueueEffect_v129",
			"Combat_ApplyDamageCodeValue_v129",
			"Combat_PlayImpactCue_v129",
			"Combat_RenderAttachmentMeshListAndTrackCursorHit_v129",
			"Combat_RenderActiveEffectsPass_v129",
			"Combat_RenderModelAttachments_v129",
			"Combat_RenderEffectModelAndCheckCursorHit_v129",
			"Combat_RenderEffectModel_v129",
			"Combat_RenderEffectModelHitProxy_v129",
			"Combat_RenderEffectSprite_v129",
			"Combat_RenderEffectTrailStrip_v129",
			"Combat_RenderWeaponEffectFallbackSpriteOrBeam_v129",
			"Combat_RenderWeaponEffectModelOrFallback_v129",
			"Combat_SpawnImpactEffectAtAttachmentOrCoord_v129",
			"Combat_ResolveProjectileImpactDamage_v129",
			"Combat_UpdateActiveProjectileEffects_v129",
			"Combat_UpdateProjectileEffectState_v129",
		],
		"edges": [
			{
				"from": "Combat_Cmd66_ActorDamageUpdate_v129",
				"to": "Combat_ApplyDamagePairOrQueueEffect_v129",
				"kind": "research-linked",
			},
			{
				"from": "Combat_Cmd67_LocalDamageUpdate_v129",
				"to": "Combat_ApplyDamagePairOrQueueEffect_v129",
				"kind": "research-linked",
			},
			{
				"from": "Combat_ApplyDamagePairOrQueueEffect_v129",
				"to": "Combat_PlayImpactCue_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_Cmd69_ImpactEffectAtCoord_v129",
				"to": "Combat_PlayImpactCue_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_SpawnImpactEffectAtAttachmentOrCoord_v129",
				"to": "Combat_PlayImpactCue_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_MainLoop_v129",
				"to": "Combat_RenderActiveEffectsPass_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActiveEffectsPass_v129",
				"to": "Combat_UpdateActiveProjectileEffects_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActiveEffectsPass_v129",
				"to": "Combat_RenderEffectModelAndCheckCursorHit_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderEffectModelAndCheckCursorHit_v129",
				"to": "Combat_RenderModelAttachments_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActiveEffectsPass_v129",
				"to": "Combat_RenderEffectSprite_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActiveEffectsPass_v129",
				"to": "Combat_RenderEffectTrailStrip_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActiveEffectsPass_v129",
				"to": "Combat_RenderWeaponEffectModelOrFallback_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActiveEffectsPass_v129",
				"to": "Combat_RenderEffectModel_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderActiveEffectsPass_v129",
				"to": "Combat_RenderEffectModelHitProxy_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderEffectModelHitProxy_v129",
				"to": "Combat_RenderAttachmentMeshListAndTrackCursorHit_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderEffectModel_v129",
				"to": "Combat_RenderAttachmentMeshListAndTrackCursorHit_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderWeaponEffectModelOrFallback_v129",
				"to": "Combat_RenderAttachmentMeshListAndTrackCursorHit_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderModelAttachments_v129",
				"to": "Combat_RenderAttachmentMeshListAndTrackCursorHit_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateActiveProjectileEffects_v129",
				"to": "Combat_UpdateProjectileEffectState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateActiveProjectileEffects_v129",
				"to": "Combat_ResolveProjectileImpactDamage_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_UpdateProjectileEffectState_v129",
				"to": "Combat_ResolveProjectileImpactDamage_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_RenderWeaponEffectModelOrFallback_v129",
				"to": "Combat_RenderWeaponEffectFallbackSpriteOrBeam_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ResolveProjectileImpactDamage_v129",
				"to": "Combat_PlayImpactCue_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "Combat_ResolveProjectileImpactDamage_v129",
				"to": "Combat_ApplyDamageCodeValue_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"world-travel-browser": {
		"title": "World Travel Browser",
		"summary": "Retail Solaris room browser, travel map overlay, list shell, and selection-submit cluster.",
		"implementation_status": "partial-analog",
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/world_client.gd",
			"res://scripts/net/world_travel_client.gd",
			"res://scripts/world/solaris_map.gd",
		],
		"research_refs": [
			"RESEARCH.md:1127-1152",
			"RESEARCH.md:6159-6161",
			"RESEARCH.md:6180-6182",
			"RESEARCH.md:6266-6295",
			"RESEARCH.md:6388-6394",
		],
		"function_names": [
			"Frame_DecodeArg_v129",
			"World_Cmd04_TravelCompassPage_v129",
			"World_Cmd34_TravelCompassLabelStrip_v129",
			"World_Cmd40_LocationBrowser_v129",
			"World_Cmd43_GroupedLocationBrowser_v129",
			"World_Cmd45_ScrollListShell_v129",
			"World_Cmd47_SetLocationLabelCode_v129",
			"World_Cmd49_MapConnectorOverlay_v129",
			"World_Cmd50_ClearLocationBrowserSelectionHighlight_v129",
			"World_Cmd51_DrawLocationBrowserSelectionHighlight_v129",
			"World_Cmd52_RejectShortcutBinding_v129",
			"World_Cmd53_ConfirmShortcutBinding_v129",
			"World_Cmd56_MapRoomMarkerOverlay_v129",
			"World_Cmd57_HotkeySelectionMenu_v129",
			"World_Cmd58_SetScrollListId_v129",
			"World_Cmd60_MapRoomMarkerOverlayWide_v129",
			"World_Cmd61_MapConnectorOverlayWide_v129",
			"World_BuildLocationBrowserWindow_v129",
			"World_ClearWorldUiChildren_v129",
			"World_EnsureLocationMapIndex_v129",
			"World_FreeLocationMapData_v129",
			"World_LoadLocationLabelBitmap_v129",
			"World_ResetLocationLabelBitmapCache_v129",
			"World_RegisterShortcutBinding_v129",
			"World_OpenStackedTextDialog_v129",
			"World_LoadLocationMapDataFile_v129",
			"World_DrawTravelCompassPageFrameArt_v129",
			"World_DrawTravelCompassSlotHatchFill_v129",
			"World_RedrawTravelCompassPageArt_v129",
			"World_RedrawTravelCompassPageHighlights_v129",
			"World_SendTravelCompassSlotSelection_v129",
			"World_SendMenuSelection_v129",
			"World_TravelCompassPage_HandleInput_v129",
			"World_TravelCompassPage_TestPointerHit_v129",
			"World_TravelCompassPage_HandleMouse_v129",
			"World_FreeShellWindowAuxBuffers_v129",
			"World_MenuDialog_HandleInput_v129",
			"World_MenuDialog_HandleMouse_v129",
			"World_HotkeySelectionMenu_HandleInput_v129",
			"World_HotkeySelectionMenu_DispatchNormalizedKey_v129",
			"World_MechStatusOptionPage_SubmitSelection_v129",
			"World_SendHotkeySelectionMenuControlFrame_v129",
		],
		"edges": [
			{
				"from": "World_Cmd04_TravelCompassPage_v129",
				"to": "World_TravelCompassPage_HandleInput_v129",
				"kind": "research-linked",
			},
			{
				"from": "World_Cmd04_TravelCompassPage_v129",
				"to": "World_TravelCompassPage_HandleMouse_v129",
				"kind": "research-linked",
			},
			{
				"from": "World_Cmd04_TravelCompassPage_v129",
				"to": "World_TravelCompassPage_TestPointerHit_v129",
				"kind": "research-linked",
			},
			{
				"from": "World_Cmd04_TravelCompassPage_v129",
				"to": "World_DrawTravelCompassPageFrameArt_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd40_LocationBrowser_v129",
				"to": "Frame_DecodeArg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd40_LocationBrowser_v129",
				"to": "World_ClearWorldUiChildren_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd50_ClearLocationBrowserSelectionHighlight_v129",
				"to": "World_BuildLocationBrowserWindow_v129",
				"kind": "research-adjacent",
			},
			{
				"from": "World_Cmd51_DrawLocationBrowserSelectionHighlight_v129",
				"to": "World_BuildLocationBrowserWindow_v129",
				"kind": "research-adjacent",
			},
			{
				"from": "World_Cmd52_RejectShortcutBinding_v129",
				"to": "World_OpenStackedTextDialog_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd53_ConfirmShortcutBinding_v129",
				"to": "World_OpenStackedTextDialog_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd57_HotkeySelectionMenu_v129",
				"to": "World_HotkeySelectionMenu_HandleInput_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd57_HotkeySelectionMenu_v129",
				"to": "World_HotkeySelectionMenu_DispatchNormalizedKey_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd57_HotkeySelectionMenu_v129",
				"to": "World_SendHotkeySelectionMenuControlFrame_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd40_LocationBrowser_v129",
				"to": "World_FreeLocationMapData_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd40_LocationBrowser_v129",
				"to": "World_EnsureLocationMapIndex_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd40_LocationBrowser_v129",
				"to": "World_BuildLocationBrowserWindow_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd43_GroupedLocationBrowser_v129",
				"to": "Frame_DecodeArg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd43_GroupedLocationBrowser_v129",
				"to": "World_ClearWorldUiChildren_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd43_GroupedLocationBrowser_v129",
				"to": "World_FreeLocationMapData_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd43_GroupedLocationBrowser_v129",
				"to": "World_EnsureLocationMapIndex_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd43_GroupedLocationBrowser_v129",
				"to": "World_BuildLocationBrowserWindow_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd47_SetLocationLabelCode_v129",
				"to": "World_LoadLocationLabelBitmap_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_TravelCompassPage_HandleInput_v129",
				"to": "World_ByteSelectionMenu_HandleInput_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_TravelCompassPage_HandleInput_v129",
				"to": "World_OpenCachedNamedEntrySelectionDialog_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_TravelCompassPage_HandleInput_v129",
				"to": "World_SendByteSelection_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_TravelCompassPage_HandleInput_v129",
				"to": "World_SendTravelCompassSlotSelection_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_TravelCompassPage_HandleMouse_v129",
				"to": "World_OpenCachedNamedEntrySelectionDialog_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_TravelCompassPage_HandleMouse_v129",
				"to": "World_SendByteSelection_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_TravelCompassPage_HandleMouse_v129",
				"to": "World_SendTravelCompassSlotSelection_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_RedrawTravelCompassPageHighlights_v129",
				"to": "World_RedrawTravelCompassPageArt_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_RedrawTravelCompassPageHighlights_v129",
				"to": "World_DrawTravelCompassSlotHatchFill_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_EnsureLocationMapIndex_v129",
				"to": "World_LoadLocationMapDataFile_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_MenuDialog_HandleInput_v129",
				"to": "World_SendMenuSelection_v129",
				"kind": "ghidra-caller",
			},
			{
				"from": "World_HotkeySelectionMenu_HandleInput_v129",
				"to": "World_SendMenuSelection_v129",
				"kind": "ghidra-caller",
			},
			{
				"from": "World_HotkeySelectionMenu_HandleInput_v129",
				"to": "World_FreeShellWindowAuxBuffers_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_MechStatusOptionPage_SubmitSelection_v129",
				"to": "World_SendMenuSelection_v129",
				"kind": "ghidra-caller",
			},
		],
	},
	"world-cached-entry-list": {
		"title": "World Cached Entry List",
		"summary": "Retail early-world cached named-entry table and follow-up text/state update cluster.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
		"function_names": [
			"World_Cmd10_ParseCachedNamedEntryList_v129",
			"World_Cmd11_UpdateCachedNamedEntryText_v129",
			"World_Cmd12_UpdateCachedNamedEntryState_v129",
			"World_Cmd13_StoreCachedNamedEntry_v129",
			"World_CreateShellWindowByStyle_v129",
			"World_FindCachedNamedEntrySlotById_v129",
			"World_OpenCachedNamedEntrySelectionDialog_v129",
			"World_CachedNamedEntrySelectionDialog_HandleInput_v129",
		],
		"edges": [
			{
				"from": "World_Cmd11_UpdateCachedNamedEntryText_v129",
				"to": "World_FindCachedNamedEntrySlotById_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd12_UpdateCachedNamedEntryState_v129",
				"to": "World_FindCachedNamedEntrySlotById_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd13_StoreCachedNamedEntry_v129",
				"to": "World_FindCachedNamedEntrySlotById_v129",
				"kind": "research-adjacent",
			},
			{
				"from": "World_OpenCachedNamedEntrySelectionDialog_v129",
				"to": "World_CachedNamedEntrySelectionDialog_HandleInput_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_OpenCachedNamedEntrySelectionDialog_v129",
				"to": "World_CreateShellWindowByStyle_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_CachedNamedEntrySelectionDialog_HandleInput_v129",
				"to": "World_SendMenuSelection_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"world-modal-pages": {
		"title": "World Modal Pages",
		"summary": "Retail shared modal and stacked text-window shell used by early world prompt, record, numeric-input, and text-dialog pages.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
			"res://scenes/mech/mech_select.gd",
		],
		"function_names": [
			"World_Cmd09_OpenNumberedTextSelection_v129",
			"World_Cmd08_MenuClose_v129",
			"World_Cmd14_PersonnelRecord_v129",
			"World_Cmd15_OpenNumericPrompt_v129",
			"World_Cmd20_ParseTextDialog_v129",
			"World_CreateShellWindowByStyle_v129",
			"World_CloseStackedShellWindow_v129",
			"World_OpenStackedShellWindow_v129",
			"World_OpenStackedTextDialog_v129",
			"World_OpenNumberedTextSelectionDialog_v129",
			"World_NumericPrompt_HandleInput_v129",
			"World_OpenModalTextWindow_v129",
			"World_OpenTextSelectionModalWindow_v129",
			"World_SendLegacySelectionResponse_v129",
		],
		"edges": [
			{
				"from": "World_Cmd09_OpenNumberedTextSelection_v129",
				"to": "World_OpenTextSelectionModalWindow_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd08_MenuClose_v129",
				"to": "World_OpenModalTextWindow_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd14_PersonnelRecord_v129",
				"to": "World_OpenModalTextWindow_v129",
				"kind": "research-adjacent",
			},
			{
				"from": "World_Cmd15_OpenNumericPrompt_v129",
				"to": "World_OpenModalTextWindow_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd15_OpenNumericPrompt_v129",
				"to": "World_NumericPrompt_HandleInput_v129",
				"kind": "research-linked",
			},
			{
				"from": "World_Cmd20_ParseTextDialog_v129",
				"to": "World_OpenStackedTextDialog_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_CreateShellWindowByStyle_v129",
				"to": "World_OpenStackedShellWindow_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_OpenStackedTextDialog_v129",
				"to": "World_CreateShellWindowByStyle_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_OpenTextSelectionModalWindow_v129",
				"to": "World_OpenNumberedTextSelectionDialog_v129",
				"kind": "research-adjacent",
			},
			{
				"from": "World_OpenNumberedTextSelectionDialog_v129",
				"to": "World_CreateShellWindowByStyle_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_OpenModalTextWindow_v129",
				"to": "World_CreateShellWindowByStyle_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_NumericPrompt_HandleInput_v129",
				"to": "World_SendLegacySelectionResponse_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_NumericPrompt_HandleInput_v129",
				"to": "World_CloseStackedShellWindow_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"world-selection-dialogs": {
		"title": "World Selection Dialogs",
		"summary": "Late-world checkbox and multi-column selection dialogs built on the shared menu-dialog shell.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/world_client.gd",
		],
		"function_names": [
			"World_Cmd42_BitmaskSelectionList_v129",
			"World_Cmd48_KeyedTripleStringList_v129",
			"World_CreateShellWindowByStyle_v129",
			"World_CloseStackedShellWindow_v129",
			"World_SendLegacySelectionResponse_v129",
			"World_MenuDialog_HandleInput_v129",
			"World_MenuDialog_HandleMouse_v129",
			"World_OpenUnkeyedTripleStringListDialog_v129",
			"World_OpenTripleStringListDialog_v129",
			"World_BitmaskSelectionList_HandleInput_v129",
		],
		"edges": [
			{
				"from": "World_Cmd42_BitmaskSelectionList_v129",
				"to": "World_CreateShellWindowByStyle_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd42_BitmaskSelectionList_v129",
				"to": "World_BitmaskSelectionList_HandleInput_v129",
				"kind": "research-linked",
			},
			{
				"from": "World_Cmd48_KeyedTripleStringList_v129",
				"to": "World_OpenTripleStringListDialog_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_OpenUnkeyedTripleStringListDialog_v129",
				"to": "World_OpenTripleStringListDialog_v129",
				"kind": "research-linked",
			},
			{
				"from": "World_OpenTripleStringListDialog_v129",
				"to": "World_CreateShellWindowByStyle_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_OpenTripleStringListDialog_v129",
				"to": "World_MenuDialog_HandleInput_v129",
				"kind": "research-linked",
			},
			{
				"from": "World_OpenTripleStringListDialog_v129",
				"to": "World_MenuDialog_HandleMouse_v129",
				"kind": "research-linked",
			},
			{
				"from": "World_BitmaskSelectionList_HandleInput_v129",
				"to": "World_SendLegacySelectionResponse_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_BitmaskSelectionList_HandleInput_v129",
				"to": "World_CloseStackedShellWindow_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"world-transient-notice-queue": {
		"title": "World Transient Notice Queue",
		"summary": "Late-world transient notice queue and popup pipeline used by queued server notices and prompt-like alert text.",
		"implementation_status": "metadata-only",
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
		"function_names": [
			"World_CreateShellWindowByStyle_v129",
			"World_CloseStackedShellWindow_v129",
			"World_Cmd29_QueueTransientNotice_v129",
			"World_OpenStackedTransientNoticeWindow_v129",
			"World_ResetTransientNoticeQueue_v129",
			"World_QueueTransientNotice_v129",
			"World_ShowNextTransientNotice_v129",
			"World_HandleTransientNoticeInput_v129",
		],
		"edges": [
			{
				"from": "World_Cmd29_QueueTransientNotice_v129",
				"to": "World_QueueTransientNotice_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd29_QueueTransientNotice_v129",
				"to": "Frame_DecodeType1Arg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd29_QueueTransientNotice_v129",
				"to": "Frame_DecodeByteArg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd29_QueueTransientNotice_v129",
				"to": "Frame_DecodeType1StringArg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_QueueTransientNotice_v129",
				"to": "World_ShowNextTransientNotice_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_ShowNextTransientNotice_v129",
				"to": "World_CreateShellWindowByStyle_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_ShowNextTransientNotice_v129",
				"to": "World_OpenStackedTransientNoticeWindow_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_OpenStackedTransientNoticeWindow_v129",
				"to": "World_CloseStackedShellWindow_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_HandleTransientNoticeInput_v129",
				"to": "World_ShowNextTransientNotice_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_HandleTransientNoticeInput_v129",
				"to": "World_CloseStackedShellWindow_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"comstar-messaging": {
		"title": "ComStar Messaging",
		"summary": "Retail read-message and compose-entry cluster for ComStar message surfaces.",
		"implementation_status": "partial-analog",
		"godot_targets": [
			"res://scenes/comstar/comstar.gd",
			"res://scripts/net/comstar_client.gd",
		],
		"research_refs": [
			"RESEARCH.md:1127-1128",
			"RESEARCH.md:6753-6757",
		],
		"function_names": [
			"Frame_DecodeArg_v129",
			"World_Cmd36_MessageView_v129",
			"World_Cmd37_OpenCompose_v129",
			"World_MessageView_HandleInput_v129",
			"World_MessageView_DispatchNormalizedKey_v129",
			"World_MessageView_ExtractReplyPrefixTags_v129",
			"World_FreeShellWindowAuxBuffers_v129",
			"World_OpenComposeEditor_v129",
			"World_ComposeEditor_SubmitMessage_v129",
			"World_ResetComposeEditorState_v129",
		],
		"edges": [
			{
				"from": "World_Cmd36_MessageView_v129",
				"to": "World_Cmd37_OpenCompose_v129",
				"kind": "research-adjacent",
			},
			{
				"from": "World_Cmd36_MessageView_v129",
				"to": "World_ResetComposeEditorState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd36_MessageView_v129",
				"to": "World_MessageView_ExtractReplyPrefixTags_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd36_MessageView_v129",
				"to": "World_MessageView_HandleInput_v129",
				"kind": "research-linked",
			},
			{
				"from": "World_Cmd36_MessageView_v129",
				"to": "World_MessageView_DispatchNormalizedKey_v129",
				"kind": "research-linked",
			},
			{
				"from": "World_Cmd37_OpenCompose_v129",
				"to": "Frame_DecodeArg_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_Cmd37_OpenCompose_v129",
				"to": "World_OpenComposeEditor_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_OpenComposeEditor_v129",
				"to": "World_ResetComposeEditorState_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_OpenComposeEditor_v129",
				"to": "World_ComposeEditor_SubmitMessage_v129",
				"kind": "research-linked",
			},
			{
				"from": "World_MessageView_HandleInput_v129",
				"to": "World_FreeShellWindowAuxBuffers_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_MessageView_HandleInput_v129",
				"to": "World_OpenComposeEditor_v129",
				"kind": "ghidra-callee",
			},
			{
				"from": "World_ComposeEditor_SubmitMessage_v129",
				"to": "World_FreeShellWindowAuxBuffers_v129",
				"kind": "ghidra-callee",
			},
		],
	},
	"mech-runtime-init": {
		"title": "Mech Runtime Init",
		"summary": "Retail mech-record to runtime-state initialization cluster.",
		"implementation_status": "partial-analog",
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
		"research_refs": [
			"RESEARCH.md:3621-3624",
		],
		"function_names": [
			"Mech_InitRuntimeStateFromRecord_v129",
			"Mech_InitComponentStatusFromRecord_v129",
			"World_Cmd26_ParseMechList_v129",
			"World_Cmd30_MechStatusOptionPage_v129",
			"World_Cmd31_MechComponentActionPage_v129",
		],
		"edges": [],
	},
	"audio-runtime": {
		"title": "KSND Audio Runtime",
		"summary": "Retail KSND parameterized sound runtime and speech/slot wrapper family.",
		"implementation_status": "partial-analog",
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
		],
		"research_refs": [],
		"function_names": [
			"KSND_C_init",
			"KSND_C_play",
			"KSND_C_setParamName",
			"KSND_C_setParamSnd",
			"KSND_C_getParamName",
			"KSND_C_getParamSnd",
			"KSND_C_shiftParamName",
			"KSND_C_shiftParamSnd",
			"KSND_C_statusName",
			"KSND_C_statusSnd",
			"KSND_C_stopName",
			"KSND_C_stopSnd",
			"KSND_C_update",
			"KSND_C_shutdown",
			"KSND_SpeechInStart",
			"KSND_SpeechInData",
			"KSND_SpeechInStop",
			"KSND_SpeechInCleanupPacket",
			"KSND_SpeechOutData",
		],
		"edges": [],
	},
	"aries-login-runtime": {
		"title": "ARIES Login Runtime",
		"summary": "Retail communication-engine login/setup, TCP connect, and login-block field setter cluster.",
		"implementation_status": "external-runtime",
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scripts/net/auth_client.gd",
			"res://scripts/net/ws_client.gd",
			"res://scripts/net/auth_session.gd",
		],
		"research_refs": [
			"RESEARCH.md:588-589",
			"RESEARCH.md:630-633",
			"RESEARCH.md:887-889",
			"RESEARCH.md:919",
			"RESEARCH.md:1021",
			"RESEARCH.md:2363-2365",
			"RESEARCH.md:2526-2528",
			"RESEARCH.md:2642",
			"RESEARCH.md:5123",
		],
		"function_names": [
			"init_aries",
			"MakeTCPConnection",
			"SendTCPData",
			"SendTCPSound",
			"SetInternet",
			"SetUserName",
			"SetUserPassword",
			"SetUserEmailHandle",
			"SetProductCode",
			"SetServerIdent",
			"CEShutDown",
		],
		"edges": [],
	},
}

static var _entries_cache: Array = []
static var _entries_by_id_cache: Dictionary = {}


static func all() -> Array:
	if _entries_cache.is_empty():
		_build_cache()
	return _entries_cache.duplicate(true)


static func by_id(subsystem_id: String) -> Dictionary:
	if _entries_cache.is_empty():
		_build_cache()
	return (_entries_by_id_cache.get(subsystem_id, {}) as Dictionary).duplicate(true)


static func by_function_name(function_name: String) -> Array:
	if _entries_cache.is_empty():
		_build_cache()
	var matches: Array = []
	for entry_v in _entries_cache:
		var entry := entry_v as Dictionary
		for function_v in entry.get("functions", []) as Array:
			var function_entry := function_v as Dictionary
			if str(function_entry.get("name", "")) == function_name or str(function_entry.get("function_name", "")) == function_name:
				matches.append(entry.duplicate(true))
				break
	return matches


static func by_target(path_fragment: String) -> Array:
	if _entries_cache.is_empty():
		_build_cache()
	var normalized := path_fragment.to_lower()
	var matches: Array = []
	for entry_v in _entries_cache:
		var entry := entry_v as Dictionary
		for target_v in entry.get("godot_targets", []) as Array:
			if str(target_v).to_lower().contains(normalized):
				matches.append(entry.duplicate(true))
				break
	return matches


static func metadata() -> Dictionary:
	return {
		"total_subsystems": all().size(),
		"implementation_statuses": _status_counts(),
	}


static func _build_cache() -> void:
	_entries_cache.clear()
	_entries_by_id_cache.clear()

	for subsystem_id in SUBSYSTEMS.keys():
		var raw := SUBSYSTEMS[subsystem_id] as Dictionary
		var entry := {
			"id": subsystem_id,
			"title": str(raw.get("title", subsystem_id)),
			"summary": str(raw.get("summary", "")),
			"implementation_status": str(raw.get("implementation_status", "metadata-only")),
			"godot_targets": (raw.get("godot_targets", []) as Array).duplicate(true),
			"research_refs": (raw.get("research_refs", []) as Array).duplicate(true),
			"functions": _resolve_functions(raw.get("function_names", []) as Array),
			"edges": (raw.get("edges", []) as Array).duplicate(true),
		}
		_entries_cache.append(entry)
		_entries_by_id_cache[subsystem_id] = entry


static func _resolve_functions(function_names: Array) -> Array:
	var functions: Array = []
	for function_name_v in function_names:
		var function_name := str(function_name_v)
		var function_entry := COMMAND_CATALOG_SCRIPT.by_function_name(function_name)
		if function_entry.is_empty():
			function_entry = HELPER_CATALOG_SCRIPT.by_function_name(function_name)
		if function_entry.is_empty():
			function_entry = FUNCTION_CATALOG_SCRIPT.by_name(function_name)
		if not function_entry.is_empty():
			functions.append(function_entry)
	return functions


static func _status_counts() -> Dictionary:
	if _entries_cache.is_empty():
		_build_cache()
	var counts := {}
	for entry_v in _entries_cache:
		var entry := entry_v as Dictionary
		var status := str(entry.get("implementation_status", "metadata-only"))
		counts[status] = int(counts.get(status, 0)) + 1
	return counts
