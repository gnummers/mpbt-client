# M10 Mobile / Tablet Feasibility

## Verdict: Experimental

The MPBT Client has been given a **foundational mobile layer** in M10.  The UI,
networking, and world/auth flows all scale correctly to mobile screens.  The 3D
combat scene has touch controls.  However, **no physical device testing has been
done**, so the mobile build is classified as **Experimental** until that
validation pass is complete.

---

## What works out of the box

| Layer | Status | Notes |
|-------|--------|-------|
| Window scaling | ✅ Ready | `canvas_items + expand` stretch gives correct 2D layout on any aspect ratio |
| All 2D scenes (main, login, world, standings, settings) | ✅ Ready | Pure Control tree, scales without modification |
| Network (REST + WebSocket) | ✅ Ready | HTTPRequest and WebSocketPeer are platform-agnostic in Godot 4 |
| Touch overlay for combat | ✅ Implemented | Virtual joystick (lower-left), look zone (right half), fire button (lower-right) |
| Mouse/keyboard combat input | ✅ Gated | Disabled on `android`/`ios` feature flags; no phantom events |
| Landscape lock | ✅ Configured | `display/window/handheld/orientation="landscape"` in project.godot |
| Android / iOS export presets | ✅ Added | Presets 3 + 4 in `export_presets.cfg` |
| Settings browse buttons | ✅ Hidden on mobile | FileDialog is desktop-only; buttons hidden via `OS.has_feature("android"/"ios")` |

---

## What needs physical device testing

| Area | Risk | Notes |
|------|------|-------|
| Touch joystick feel | Medium | MOUSE_SENSITIVITY (0.0025) was tuned for mouse; may need a separate TOUCH_SENSITIVITY constant |
| 3D combat GPU performance | High | Forward Plus renderer is desktop-class; may need to switch to Mobile renderer for acceptable FPS on mid-range phones |
| WebSocket on iOS | Medium | iOS background networking rules may close the WS socket; test with app in foreground |
| Android permissions | Low | `internet_permission` is enabled; no storage or camera permissions needed |
| FileDialog path on Android | N/A | Browse buttons are hidden on mobile; user types paths manually if needed |

---

## Known limitations

- **Combat is the only scene with touch controls.** World map, standings, and
  other scenes work via tap (touch emulates mouse click) but have no
  mobile-specific UX polish.
- **Settings FileDialog** — browse buttons are hidden on Android/iOS.  Users
  must type retail/extracted asset paths manually (those paths are irrelevant
  for mobile anyway, as asset extraction happens on desktop).
- **Mech piloting feel** — the virtual joystick base repositions to the first
  touch point, which works well for thumb comfort on any phone size.  However,
  the look sensitivity (right-side drag) is inherited from mouse sensitivity and
  may feel slow or fast depending on device DPI.
- **iOS export** — requires macOS + Xcode.  The Godot headless export command
  in PACKAGING.md does not work cross-platform for iOS.

---

## Promoting from Experimental to Supported

Before calling mobile "supported," complete:

1. **Test on physical Android device** — verify touch joystick, look zone, fire button, WS connection, FPS.
2. **Switch renderer if needed** — in project.godot change `Forward Plus` → `Mobile` for better mobile GPU performance.
3. **Tune touch sensitivity** — add a separate `TOUCH_LOOK_SENSITIVITY` constant in `combat.gd` if the default 0.0025 is unsatisfactory.
4. **Test iOS on macOS + Xcode** — build and deploy to physical device via Xcode instruments.
5. **Add a renderer toggle** in Settings (Advanced section) so users can switch between Forward Plus and Mobile renderer.
6. Update this document and change verdict from **Experimental** to **Supported (Android)** / **Supported (iOS)**.

---

## Build commands

```bash
# Android APK (requires Android SDK + JDK installed and configured in Godot)
godot --headless --export-release "Android" builds/android/mpbt-client.apk

# iOS (requires macOS + Xcode; run on macOS only)
godot --headless --export-release "iOS" builds/ios/mpbt-client.ipa
```

See [PACKAGING.md](PACKAGING.md) for export template installation and desktop build instructions.
