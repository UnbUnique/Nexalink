package com.nexalink.nearby.permission

import android.Manifest
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.pm.PackageManager
import android.location.LocationManager
import android.net.wifi.WifiManager
import android.os.Build
import androidx.core.content.ContextCompat
import androidx.core.location.LocationManagerCompat

/**
 * Utility helper to determine, verify runtime permissions, and check hardware radio readiness
 * (Bluetooth, Wi-Fi, Location) required by Google Nearby Connections across different Android OS versions.
 *
 * Requirements vary by Android version:
 * - Android 13+ (API 33+): BLUETOOTH_SCAN, BLUETOOTH_ADVERTISE, BLUETOOTH_CONNECT, NEARBY_WIFI_DEVICES, ACCESS_FINE_LOCATION
 * - Android 12+ (API 31-32): BLUETOOTH_SCAN, BLUETOOTH_ADVERTISE, BLUETOOTH_CONNECT, ACCESS_FINE_LOCATION
 * - Android 11 and lower (API <= 30): ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION
 */
object NearbyPermissions {

    data class HardwareStatus(
        val isBluetoothOn: Boolean,
        val isLocationOn: Boolean,
        val isWifiOn: Boolean
    ) {
        val isReadyForNearby: Boolean
            get() = isBluetoothOn && isLocationOn
    }

    /**
     * Returns the exact array of runtime permissions required on the current Android version.
     */
    fun getRequiredPermissions(): Array<String> {
        return when {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU -> {
                arrayOf(
                    Manifest.permission.BLUETOOTH_SCAN,
                    Manifest.permission.BLUETOOTH_ADVERTISE,
                    Manifest.permission.BLUETOOTH_CONNECT,
                    Manifest.permission.NEARBY_WIFI_DEVICES,
                    Manifest.permission.ACCESS_FINE_LOCATION
                )
            }
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
                arrayOf(
                    Manifest.permission.BLUETOOTH_SCAN,
                    Manifest.permission.BLUETOOTH_ADVERTISE,
                    Manifest.permission.BLUETOOTH_CONNECT,
                    Manifest.permission.ACCESS_FINE_LOCATION
                )
            }
            else -> {
                arrayOf(
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.ACCESS_COARSE_LOCATION
                )
            }
        }
    }

    /**
     * Checks if all runtime permissions required by Nearby Connections are granted.
     *
     * @param context Application or Activity context.
     * @return true if every required permission is GRANTED, false otherwise.
     */
    fun hasAllPermissions(context: Context): Boolean {
        return getRequiredPermissions().all { permission ->
            ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED
        }
    }

    /**
     * Returns a list of permissions that have not yet been granted by the user.
     *
     * @param context Application or Activity context.
     * @return List of permission string identifiers that need to be requested.
     */
    fun getMissingPermissions(context: Context): List<String> {
        return getRequiredPermissions().filter { permission ->
            ContextCompat.checkSelfPermission(context, permission) != PackageManager.PERMISSION_GRANTED
        }
    }

    /**
     * Checks if Bluetooth is enabled on the device.
     */
    fun isBluetoothEnabled(context: Context): Boolean {
        val bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager
        return bluetoothManager?.adapter?.isEnabled ?: false
    }

    /**
     * Checks if Location Services (GPS/Network Location) is enabled in Android Settings.
     * Essential for Nearby Connections BLE discovery.
     */
    fun isLocationEnabled(context: Context): Boolean {
        val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as? LocationManager
        return locationManager?.let { LocationManagerCompat.isLocationEnabled(it) } ?: false
    }

    /**
     * Checks if Wi-Fi hardware is enabled on the device.
     */
    fun isWifiEnabled(context: Context): Boolean {
        val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as? WifiManager
        return wifiManager?.isWifiEnabled ?: false
    }

    /**
     * Returns the overall hardware readiness for Google Nearby Connections.
     */
    fun checkHardwareStatus(context: Context): HardwareStatus {
        return HardwareStatus(
            isBluetoothOn = isBluetoothEnabled(context),
            isLocationOn = isLocationEnabled(context),
            isWifiOn = isWifiEnabled(context)
        )
    }
}
