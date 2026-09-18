package com.campusmesh.nearby

import com.campusmesh.nearby.flutter.NearbyPlatformChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

/**
 * MainActivity
 *
 * Configures FlutterEngine and registers the [NearbyPlatformChannel]
 * so Flutter Dart code can communicate with the native Google Nearby Connections layer.
 */
class MainActivity : FlutterActivity() {

    private var platformChannel: NearbyPlatformChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        platformChannel = NearbyPlatformChannel(
            context = applicationContext,
            messenger = flutterEngine.dartExecutor.binaryMessenger
        ).apply {
            register()
        }
    }

    override fun onDestroy() {
        platformChannel?.unregister()
        super.onDestroy()
    }
}
