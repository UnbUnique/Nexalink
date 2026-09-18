# CampusMesh 📡📱

> **Offline Peer-to-Peer Academic Communication Layer & Mobile Application**

**CampusMesh** is an offline-first, decentralized peer-to-peer (P2P) academic communication application designed for students and faculty. It enables seamless offline classroom communication, encrypted chat threads, professor broadcast logs, mesh topology visualization with real-time radar, active course channel handover, and emergency safety overrides without requiring internet connectivity.

Under the hood, it uses Google Nearby Connections (`Strategy.P2P_CLUSTER`) across Wi-Fi Direct and Bluetooth Low Energy, coupled with a high-fidelity Flutter frontend.

---

## 📱 Features & Prototype Screen Alignment

| Screen / Feature | Prototype Source | Implementation in Flutter |
| :--- | :--- | :--- |
| **Welcome Screen** | `welcome_screen/` | `WelcomeScreen` featuring neon teal & purple gradient hero card, live nearby peer avatar stack, role selection cards (Teacher / Student), and encryption badges. |
| **Student Login** | `student_login/` | `StudentLoginScreen` with Student ID (`STU-2024-8842`), passcode toggle, device trust toggle with local key `#8F2A`, and mesh status banner. |
| **Faculty Login** | `teacher_login/` | `TeacherLoginScreen` with campus email (`teacher@campus.edu`), encrypted credentials card, and mesh diagnostics link. |
| **Student Dashboard** | `student_dashboard/` | `StudentDashboardView` with Alex Chen profile, My Mesh ID QR dialog, active class channels (CS-301, CS-350), verified professor broadcasts feed, and recent conversations. |
| **Teacher Dashboard** | `teacher_dashboard/` | `TeacherDashboardView` with Dr. Alan Grant banner, connected peers stat (`24`, `+3 new`), active broadcasts stat (`3 live rooms`), quick action buttons, and recent mesh broadcast log. |
| **Class Channel Switcher** | `class_selection/` | `ClassSelectionScreen` with channel search, filter, peer density, sync status, and simulated network handover connection spinner. |
| **Mesh Topology & Radar** | `connected_devices/` | `ConnectedDevicesScreen` with custom canvas `MeshRadarWidget` rendering concentric rings, rotating sweep radar, orbiting peer pins, and connected device telemetry (RSSI dBm, hops, battery). |
| **P2P Message History & Chat** | `message_history/` | `MessageHistoryScreen` with filter chips (*All Threads, Direct P2P, Mesh Broadcasts, Sync Queue*) and interactive slide-up `ChatConversationSheet` with dark message bubbles and delivery checks. |
| **Broadcast Hub Composer** | `send_announcement/` | `SendAnnouncementScreen` with class selector, priority selector (Normal, Important, Emergency), character counter, multi-hop relay toggle, and animated hop propagation simulation. |
| **Urgent Safety Alert** | `urgent_alert/` | `UrgentAlertScreen` with Critical Override emergency banner, affected sectors list with severity tags, and interactive "Acknowledge & Confirm Receipt" CTA. |

---

## 🎨 Design System

Mapped strictly from `campusmesh_design_system/DESIGN.md`:
- **Canvas / Surface**: `#111317` (Deep OLED black)
- **Elevations**: `#1A1C1F` (low), `#1E2023` (container), `#282A2D` (high), `#333538` (highest)
- **Primary**: `#D0BCFF` (Electric Purple)
- **Secondary**: `#4CD7F6` (Neon Teal / Cyan)
- **Error / Alert**: `#FFB4AB` / `#93000A` / `#DC2626`
- **Typography**: `Inter` for UI & reading surfaces; `JetBrains Mono` for badges, timestamps, codes, and metrics.
- **Ghost Borders**: `1px solid rgba(255, 255, 255, 0.08)`

---

## 📂 Repository Structure

- `app/src/main/java/com/campusmesh/nearby/`: Native Android Nearby communication layer
  - `NearbyManager.kt`: Core offline communication engine (advertising, discovery, messaging).
  - `model/`: Data models (`ChatMessage`, `PeerDevice`, `DiscoveredDevice`, `ConnectionState`, `NearbyEvent`).
  - `permission/NearbyPermissions.kt`: Runtime permissions helper & hardware radio pre-checks.
  - `flutter/NearbyPlatformChannel.kt`: Native Android platform channel bridge for Flutter frontends.
  - `MainActivity.kt`: Android entry point with FlutterEngine integration.
- `app/src/main/AndroidManifest.xml`: Required Bluetooth, Wi-Fi Direct, and Location permissions.
- `lib/`: Flutter Application Frontend
  - `core/`: Constants, tokens (`app_colors.dart`, `app_typography.dart`, `app_theme.dart`), and custom widgets.
  - `data/`: Data models and mock dataset.
  - `state/`: State management providers (app, broadcast, mesh network, messages).
  - `presentation/`: UI screens (welcome, login, dashboards, radar, class selection, announcements, urgent alerts).
  - `services/nearby_service.dart`: Reactive Flutter singleton service for native bridge.
  - `models/nearby_models.dart`: Dart models matching native data.
- `stitch_campusmesh_ui_prototype/`: UI prototype design files and specs.

---

## 🚀 How to Run

### Flutter Frontend (Web / Desktop / Mobile)
```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run the application
flutter run -d chrome
# or
flutter run -d windows
```

### Native Android Offline Testing Flow
1. Open the project in Android Studio or VS Code with Flutter SDK.
2. Two physical Android devices (emulators cannot test Bluetooth/Wi-Fi Direct radios).
3. Ensure Bluetooth and Wi-Fi toggles are **ON** (Mobile Data and Internet can be completely **OFF**).
4. **Phone A** starts advertising: `nearbyManager.startAdvertising("Phone A")`.
5. **Phone B** starts discovery: `nearbyManager.startDiscovery()`.
6. Phone B selects Phone A and connects. Handshake is auto-accepted.
7. Send offline message: `nearbyManager.sendMessage(endpointId, "Hello")`.
