# CampusMesh 📡📱

> **Offline Peer-to-Peer Communication Layer for CampusMesh (Hackathon Project)**

CampusMesh enables Android devices to discover each other, connect, and exchange real-time text messages **completely offline** with mobile data and internet turned off, using Google Nearby Connections (`Strategy.P2P_CLUSTER`).

---

## 📁 Repository Structure

- `app/src/main/java/com/campusmesh/nearby/`
  - `NearbyManager.kt`: Core offline communication engine (advertising, discovery, messaging).
  - `model/`: Data models (`ChatMessage`, `PeerDevice`, `DiscoveredDevice`, `ConnectionState`, `NearbyEvent`).
  - `permission/NearbyPermissions.kt`: Runtime permissions helper & hardware radio pre-checks.
  - `flutter/NearbyPlatformChannel.kt`: Native Android platform channel bridge for Flutter frontends.
  - `MainActivity.kt`: Android entry point with FlutterEngine integration.
- `app/src/main/AndroidManifest.xml`: Required Bluetooth, Wi-Fi Direct, and Location permissions.
- `lib/`: (Optional for Flutter frontends)
  - `services/nearby_service.dart`: Reactive Flutter singleton service.
  - `models/nearby_models.dart`: Dart models matching native data.

---

## 🚀 Quick Setup for Teammates

### Prerequisites
1. Android Studio or VS Code with Flutter SDK.
2. Two physical Android devices (emulators cannot test Bluetooth/Wi-Fi Direct radios).
3. Both devices must have Bluetooth and Location enabled in quick settings.

### Offline Testing Flow
1. Turn **OFF** Mobile Data and Wi-Fi Internet on both phones.
2. Ensure **Bluetooth and Wi-Fi toggles** are **ON**.
3. **Phone A** starts advertising: `nearbyManager.startAdvertising("Phone A")`.
4. **Phone B** starts discovery: `nearbyManager.startDiscovery()`.
5. Phone B selects Phone A and connects. Handshake is auto-accepted.
6. Send offline message: `nearbyManager.sendMessage(endpointId, "Hello")`.
