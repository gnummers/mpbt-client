class_name RetailFunctionCatalog
extends RefCounted

## Curated import of the currently saved/named retail v1.29 symbols from the
## active Ghidra project for mpbtwin.exe.
##
## The wider Ghidra custom-name inventory currently contains 260 symbols, but a
## large portion of that set is CRT/FID/runtime noise. This catalog keeps the
## gameplay/audio/network/system names that are presently useful to the Godot
## client while preserving their retail addresses and xref counts.

const PROGRAM_NAME := "mpbtwin.exe"
const IMAGE_BASE := "00400000"
const GHIDRA_CUSTOM_NAMED_TOTAL := 352
const IMPORT_FILTER := "^(Combat|World|Mech|Frame|KSND|Make|Send|Set|init_aries|CEShutDown|DirectDrawCreate|RtlUnwind).*$"

const RAW_ROWS := [
	["CEShutDown", "0046df0a", 1],
	["Combat_AdvanceAnimationControllerState_v129", "00429810", 1],
	["Combat_AnimCallback_ClearActorRecoveryBlock_v129", "00436570", 1],
	["Combat_ApplyDamageCodeValue_v129", "0042a990", 2],
	["Combat_ApplyDamagePairOrQueueEffect_v129", "0042a700", 2],
	["Combat_ClearExpiredWeaponSlotIndicators_v129", "00410b70", 1],
	["Combat_ArmDeferredCollapseWhileAirborne_v129", "004091c0", 2],
	["Combat_DrawLocalAirborneHudReadout_v129", "00419e30", 1],
	["Combat_BuildActorAnimationPose_v129", "00428990", 3],
	["Combat_BuildAnimationNodePoseRecursive_v129", "00428e10", 2],
	["Combat_Cmd59_ConfigureVoiceTransmission_v129", "0042b550", 0],
	["Combat_Cmd60_UpdateActorVoiceTransmissionState_v129", "0042b4e0", 0],
	["Combat_Cmd61_SetVoiceTransmissionTuneToChannelId_v129", "0042b470", 0],
	["Combat_Cmd62_StartCombat_v129", "0042a010", 0],
	["Combat_Cmd63_ResultSceneInit_v129", "00404bc0", 1],
	["Combat_Cmd64_AddActor_v129", "00429bb0", 0],
	["Combat_Cmd65_UpdateActorPosition_v129", "0042a050", 0],
	["Combat_Cmd66_ActorDamageUpdate_v129", "0042a6a0", 0],
	["Combat_Cmd67_LocalDamageUpdate_v129", "0042a6e0", 0],
	["Combat_Cmd68_SpawnWeaponEffect_v129", "0042ac60", 0],
	["Combat_Cmd69_ImpactEffectAtCoord_v129", "0042ae50", 0],
	["Combat_Cmd70_ActorAnimState_v129", "0042b000", 0],
	["Combat_Cmd71_ResetEffectState_v129", "0042b400", 0],
	["Combat_Cmd72_InitLocalActor_v129", "00404420", 0],
	["Combat_Cmd73_UpdateActorRateFields_v129", "0042aba0", 0],
	["Combat_Cmd74_DisplayStatusMessage_v129", "00404d40", 0],
	["Combat_FindAnimationStateDefinitionById_v129", "00428d50", 4],
	["Combat_GetAnimationNodeByStateTag_v129", "00436530", 1],
	["Combat_IntegrateActorMotion_v129", "00408700", 2],
	["Combat_IsActorRecoverableSupportIntact_v129", "0040f4e0", 15],
	["Combat_JumpJetInputTick_v129", "00416570", 1],
	["Combat_MainLoop_v129", "00406530", 1],
	["Combat_UpdateUpperBodyAimCueAudio_v129", "00407600", 1],
	["Combat_ProcessMouseThrottleZoneInput_v129", "0040b8b0", 1],
	["Combat_ProcessMouseChassisTurnInput_v129", "0040b790", 1],
	["Combat_ComputeMouseTurnAxisPercent_v129", "0040b820", 3],
	["Combat_GetMouseControlZoneConfig_v129", "0040bb10", 4],
	["Combat_ProcessMouseUpperBodyAimInput_v129", "004076c0", 1],
	["Combat_ProcessMouseUpperBodyAimZones_v129", "0040b5f0", 1],
	["Combat_ApplyChassisTurnInputRate_v129", "0042ff40", 2],
	["Combat_ComputeActorForwardSpeedComponent_v129", "00410650", 5],
	["Combat_ApplyTorsoYawInputRate_v129", "0042ff80", 2],
	["Combat_ApplyUpperBodyPitchInputRate_v129", "0042ffe0", 2],
	["Combat_ApplyLocalMovementForces_v129", "004106e0", 1],
	["Combat_DampenLocalMotionState_v129", "00410cd0", 1],
	["Combat_PlayAudioCue_v129", "0044e080", 50],
	["Combat_SpawnImpactEffectAtAttachmentOrCoord_v129", "00417b90", 2],
	["Combat_PlayImpactCue_v129", "0040bfe0", 4],
	["Combat_ProcessChassisTurnInput_v129", "00416380", 1],
	["Combat_ProcessUpperBodyAimInput_v129", "00416460", 1],
	["Combat_PlayCollapseImpactCue_v129", "0040c100", 2],
	["Combat_RenderActorPreviewPanel_v129", "00449070", 2],
	["Combat_RenderAttachmentMeshListAndTrackCursorHit_v129", "0040a3d0", 4],
	["Combat_RenderActiveEffectsPass_v129", "00449d90", 1],
	["Combat_RenderModelAttachments_v129", "00428770", 2],
	["Combat_RenderEffectModelAndCheckCursorHit_v129", "004499d0", 1],
	["Combat_RenderEffectModel_v129", "00436c60", 1],
	["Combat_RenderEffectModelHitProxy_v129", "00439b00", 1],
	["Combat_RenderEffectSprite_v129", "0043d1e0", 1],
	["Combat_RenderEffectTrailStrip_v129", "0044dbe0", 1],
	["Combat_RenderWeaponEffectFallbackSpriteOrBeam_v129", "0043b970", 1],
	["Combat_RenderWeaponEffectModelOrFallback_v129", "0043b250", 1],
	["Combat_ResolveProjectileImpactDamage_v129", "0043b790", 2],
	["Combat_UpdateActiveProjectileEffects_v129", "0043b030", 1],
	["Combat_UpdateProjectileEffectState_v129", "0043b2a0", 1],
	["Combat_StopAudioCue_v129", "0044e180", 6],
	["Combat_IsAudioCuePlaying_v129", "0044e210", 12],
	["Combat_SetAudioCueVolume_v129", "0044e250", 5],
	["Combat_SetAudioCuePitch_v129", "0044e350", 5],
	["Combat_UpdateLocalThrottleFeedbackAudio_v129", "0040bed0", 2],
	["Combat_UpdateHeatShutdownState_v129", "004110b0", 1],
	["Combat_ProcessLocalMechContact_v129", "00407ff0", 1],
	["Combat_ProcessLocalMovementAndJumpInput_v129", "0044d230", 1],
	["Combat_ResetLocalMotionAndRefreshAnimation_v129", "00409140", 2],
	["Combat_ResolveLandingOrGroundContact_v129", "00408220", 1],
	["Combat_SendCmd12Action_v129", "0042b440", 3],
	["Combat_SetActorAnimationState_v129", "004292d0", 12],
	["Combat_StartFallDownAnim_SetRecoveryBlock_v129", "00436640", 5],
	["Combat_TickLocalActorControlLoop_v129", "00410f60", 1],
	["Combat_RecenterUpperBodyAimOffsets_v129", "00430040", 1],
	["Combat_AccumulateTorsoYawOffset_v129", "00430160", 2],
	["Combat_AccumulateUpperBodyPitchOffset_v129", "004301c0", 2],
	["Combat_UpdateJumpFuelReserve_v129", "00410340", 1],
	["Combat_UpdateLocalHeatAccumulator_v129", "00410090", 1],
	["Combat_UpdateWeaponRangeIndicators_v129", "00410a40", 1],
	["Combat_UpdateAnimationControllerProgress_v129", "00428d80", 1],
	["Combat_UpdateLocalMovementHudAndAnimation_v129", "00419f50", 15],
	["Combat_UpdateLocalThrottleTarget_v129", "00416230", 17],
	["DirectDrawCreate", "0046df22", 1],
	["Frame_BlitRelativeRect_v129", "0041ee30", 16],
	["Frame_BlitBitmapWithTransparentKey_v129", "0044c3d0", 7],
	["Frame_BlitBitmapPixels_v129", "0044c270", 8],
	["Frame_CompositeMaskedSpanRuns_v129", "0044a4e0", 3],
	["Frame_CopyBitmapPixelsToBuffer_v129", "0044c330", 1],
	["Frame_DecodeArg_v129", "00430220", 100],
	["Frame_DecodeBitmapRleData_v129", "0044c1f0", 3],
	["Frame_DrawLine_v129", "0041c070", 18],
	["Frame_DrawLineAndPresent_v129", "0041c0c0", 18],
	["Frame_DrawBeveledRectAndPresent_v129", "0041c170", 1],
	["Frame_DrawFilledBoxOrBitmapDecoration_v129", "0041bf00", 3],
	["Frame_DrawFilledCircleSector_v129", "0041f280", 1],
	["Frame_DrawFormattedText_v129", "0041e860", 62],
	["Frame_DrawInlineAssetRuns_v129", "00444a30", 1],
	["Frame_DrawBeveledFillBar_v129", "0041f1b0", 1],
	["Frame_DrawGlyph_v129", "0045742f", 1],
	["Frame_DrawString_v129", "004575c2", 8],
	["Frame_DrawBeveledRect_v129", "0041c320", 3],
	["Frame_DrawBeveledBorderDecoration_v129", "0041c4d0", 6],
	["Frame_DrawWrappedLine_v129", "00444ee0", 1],
	["Frame_DrawWrappedTextBlock_v129", "00444c80", 8],
	["Frame_DrawBitmapResourceTransparentAt_v129", "0041f0d0", 11],
	["Frame_GetGlyphAdvance_v129", "0042b720", 5],
	["Frame_MeasureGlyphRunWidth_v129", "0041bcc0", 1],
	["Frame_MeasureStringWidth_v129", "0041bd20", 13],
	["Frame_ScrollTextViewportUpIfAtBottom_v129", "0041e6d0", 2],
	["Frame_AppendWrappedInputChar_v129", "00444730", 0],
	["Frame_BackspaceWrappedInputChar_v129", "00444f30", 0],
	["Frame_DrawTextDecorationByIndex_v129", "0041cb70", 8],
	["Frame_WriteCharAtCursor_v129", "0041e560", 7],
	["Frame_WriteCharAtLineColumn_v129", "0041e740", 2],
	["Frame_GetCurrentWrappedLineText_v129", "00446a30", 2],
	["Frame_GetFontLineHeight_v129", "004573fc", 2],
	["Frame_ResetTextLayoutState_v129", "0041de70", 7],
	["Frame_ResetTextLayoutStateWithInsets_v129", "0041df00", 11],
	["Frame_RedrawRegisteredTextDecorations_v129", "0041de30", 2],
	["Frame_SwapPaletteIndicesInRect_v129", "00420140", 39],
	["Frame_UpdateTextCursorHighlight_v129", "0041d470", 6],
	["Frame_DrawBitmapResourceAt_v129", "0041f070", 100],
	["KSND_C_getParamName", "0046dec8", 1],
	["KSND_C_getParamSnd", "0046dea4", 2],
	["KSND_C_init", "0046de8c", 1],
	["KSND_C_panic", "0046de80", 1],
	["KSND_C_play", "0046de7a", 17],
	["KSND_C_readKDT", "0046de86", 1],
	["KSND_C_setParamName", "0046debc", 5],
	["KSND_C_setParamSnd", "0046de74", 24],
	["KSND_C_shiftParamName", "0046dec2", 1],
	["KSND_C_shiftParamSnd", "0046de9e", 2],
	["KSND_C_shutdown", "0046de92", 1],
	["KSND_C_statusName", "0046ded4", 1],
	["KSND_C_statusSnd", "0046de98", 6],
	["KSND_C_stopName", "0046dece", 1],
	["KSND_C_stopSnd", "0046deaa", 3],
	["KSND_C_update", "0046de6e", 2],
	["KSND_SpeechInCleanupPacket", "0046de62", 3],
	["KSND_SpeechInData", "0046de68", 1],
	["KSND_SpeechInStart", "0046deb0", 3],
	["KSND_SpeechInStop", "0046deb6", 2],
	["KSND_SpeechOutData", "0046de5c", 3],
	["MakeSocketWindow", "0046df10", 1],
	["MakeTCPConnection", "0046def2", 1],
	["Mech_InitComponentStatusFromRecord_v129", "00415a60", 5],
	["Mech_InitRuntimeStateFromRecord_v129", "004157a0", 4],
	["RtlUnwind", "00477f50", 1],
	["SendTCPData", "0046df16", 1],
	["SendTCPSound", "0046df04", 2],
	["SetInternet", "0046deda", 1],
	["SetProductCode", "0046deec", 1],
	["SetServerIdent", "0046dee6", 1],
	["SetUserEmailHandle", "0046dee0", 1],
	["SetUserName", "0046defe", 1],
	["SetUserPassword", "0046def8", 1],
	["World_BuildLocationBrowserWindow_v129", "00432450", 2],
	["World_BuyExtraAmmoList_HandleKey_v129", "00427a40", 1],
	["World_BuyExtraAmmoList_HandlePointer_v129", "004275f0", 1],
	["World_ClearWorldUiChildren_v129", "00440f30", 5],
	["World_Cmd07_MenuDialog_v129", "0043e0f0", 0],
	["World_Cmd08_MenuClose_v129", "00440780", 0],
	["World_Cmd14_PersonnelRecord_v129", "00442620", 0],
	["World_Cmd20_ParseTextDialog_v129", "0043ebc0", 0],
	["World_Cmd26_ParseMechList_v129", "00423df0", 0],
	["World_Cmd27_AlternateMechChooser_v129", "00424130", 0],
	["World_Cmd30_MechStatusOptionPage_v129", "00424fb0", 0],
	["World_Cmd31_MechComponentActionPage_v129", "00425d60", 0],
	["World_Cmd32_AlternateRankingList_v129", "00423fa0", 0],
	["World_Cmd36_MessageView_v129", "004430b0", 0],
	["World_Cmd37_OpenCompose_v129", "00443d10", 0],
	["World_Cmd39_BuyExtraAmmoList_v129", "00427730", 0],
	["World_Cmd40_LocationBrowser_v129", "00432540", 0],
	["World_Cmd41_NameMechScoreMatrix_v129", "00442a00", 0],
	["World_Cmd42_BitmaskSelectionList_v129", "0043f4c0", 0],
	["World_Cmd43_GroupedLocationBrowser_v129", "00432800", 0],
	["World_Cmd44_SetLocationDistanceScale_v129", "00433940", 0],
	["World_Cmd45_ScrollListShell_v129", "0042f5b0", 0],
	["World_Cmd46_ClearWorldUiChildren_v129", "00440f80", 0],
	["World_Cmd48_KeyedTripleStringList_v129", "0043ec20", 0],
	["World_Cmd49_MapConnectorOverlay_v129", "004332b0", 0],
	["World_Cmd54_SetCurrentUnitCode_v129", "00446870", 0],
	["World_Cmd55_SetCurrentHouseCode_v129", "00446890", 0],
	["World_Cmd56_MapRoomMarkerOverlay_v129", "004336a0", 0],
	["World_Cmd57_HotkeySelectionMenu_v129", "004438b0", 0],
	["World_Cmd58_SetScrollListId_v129", "0042f5a0", 0],
	["World_Cmd59_FailStub_v129", "0042fba0", 0],
	["World_Cmd60_MapRoomMarkerOverlayWide_v129", "004337f0", 0],
	["World_Cmd61_MapConnectorOverlayWide_v129", "00433340", 0],
	["World_EnsureLocationMapIndex_v129", "00433d00", 4],
	["World_FreeLocationMapData_v129", "00433ca0", 3],
	["World_HotkeySelectionMenu_HandleInput_v129", "00443650", 1],
	["World_LoadLocationMapDataFile_v129", "004339f0", 2],
	["World_MechComponentActionPage_HandleActionHotkey_v129", "00426ef0", 1],
	["World_MechComponentActionPage_HandleKey_v129", "00426f90", 1],
	["World_MechComponentActionPage_HandlePointer_v129", "00424cb0", 1],
	["World_MechStatusOptionPage_SubmitSelection_v129", "00424a50", 1],
	["World_MenuDialog_HandleInput_v129", "0043efc0", 3],
	["World_MenuDialog_HandleMouse_v129", "0043f110", 3],
	["World_OpenComposeEditor_v129", "00443d80", 3],
	["World_RegisterShortcutBinding_v129", "00429a40", 1],
	["World_ResetComposeEditorState_v129", "00443fb0", 2],
	["World_SendCmd1dControlFrame_v129", "0043db30", 31],
	["World_SendMenuSelection_v129", "0042f990", 21],
	["init_aries", "0046df1c", 1],
]

static var _entries_cache: Array = []
static var _entries_by_name_cache: Dictionary = {}


static func all() -> Array:
	if _entries_cache.is_empty():
		_build_cache()
	return _entries_cache.duplicate(true)


static func by_name(name: String) -> Dictionary:
	if _entries_cache.is_empty():
		_build_cache()
	return (_entries_by_name_cache.get(name, {}) as Dictionary).duplicate(true)


static func by_group(group: String) -> Array:
	if _entries_cache.is_empty():
		_build_cache()
	var normalized := group.strip_edges().to_lower()
	var matches: Array = []
	for entry in _entries_cache:
		if str(entry.get("group", "")).to_lower() == normalized:
			matches.append((entry as Dictionary).duplicate(true))
	return matches


static func groups() -> Dictionary:
	if _entries_cache.is_empty():
		_build_cache()
	var counts := {}
	for entry_v in _entries_cache:
		var entry := entry_v as Dictionary
		var group := str(entry.get("group", "Unsorted"))
		counts[group] = int(counts.get(group, 0)) + 1
	return counts


static func metadata() -> Dictionary:
	return {
		"program": PROGRAM_NAME,
		"image_base": IMAGE_BASE,
		"ghidra_custom_named_total": GHIDRA_CUSTOM_NAMED_TOTAL,
		"imported_count": RAW_ROWS.size(),
		"import_filter": IMPORT_FILTER,
		"groups": groups(),
	}


static func _build_cache() -> void:
	_entries_cache.clear()
	_entries_by_name_cache.clear()

	for row_v in RAW_ROWS:
		var row := row_v as Array
		var name := str(row[0])
		var entry := {
			"name": name,
			"address": str(row[1]),
			"xref_count": int(row[2]),
			"group": _group_for_name(name),
		}
		_entries_cache.append(entry)
		_entries_by_name_cache[name] = entry


static func _group_for_name(name: String) -> String:
	if name.begins_with("Combat_"):
		return "Combat"
	if name.begins_with("World_"):
		return "World"
	if name.begins_with("Mech_"):
		return "Mech"
	if name.begins_with("Frame_"):
		return "Network"
	if name.begins_with("KSND_"):
		return "Audio"
	if name in [
		"MakeSocketWindow",
		"MakeTCPConnection",
		"SendTCPData",
		"SendTCPSound",
		"SetInternet",
		"SetProductCode",
		"SetServerIdent",
		"SetUserEmailHandle",
		"SetUserName",
		"SetUserPassword",
		"init_aries",
	]:
		return "Network"
	return "System"
