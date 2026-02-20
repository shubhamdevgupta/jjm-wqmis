package com.example.jjm_wqmis

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Bundle
import android.os.Looper
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.example/location_permission"

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationManager: LocationManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        fusedLocationClient =
            LocationServices.getFusedLocationProviderClient(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                when (call.method) {

                    "requestPermission" -> {
                        result.success(requestLocationPermission())
                    }

                    "getLocation" -> {
                        getCurrentLocation(result)
                    }

                    "isLocationServiceEnabled" -> {
                        result.success(isLocationEnabled())
                    }

                    "openLocationSettings" -> {
                        openLocationSettings()
                        result.success(true)
                    }

                    "getVersionName" -> {
                        try {
                            val pInfo = applicationContext.packageManager
                                .getPackageInfo(applicationContext.packageName, 0)
                            result.success(pInfo.versionName)
                        } catch (e: PackageManager.NameNotFoundException) {
                            result.error("UNAVAILABLE", "Version name not available.", null)
                        }
                    }

                    "getSecretKey" -> {
                        result.success(getSecretKey())
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun getSecretKey(): String {
        return "8080808080808080"
    }

    private fun requestLocationPermission(): Boolean {
        if (ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                100
            )
            return false
        }
        return true
    }

    private fun isLocationEnabled(): Boolean {
        locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
                || locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
    }

    private fun openLocationSettings() {
        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
    }

    // 🔥 PRODUCTION LEVEL LOCATION FETCH
    private fun getCurrentLocation(result: MethodChannel.Result) {

        if (ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            result.success(null)
            return
        }

        // First try last known location
        fusedLocationClient.lastLocation
            .addOnSuccessListener { location ->
                if (location != null) {
                    result.success(
                        mapOf(
                            "latitude" to location.latitude,
                            "longitude" to location.longitude
                        )
                    )
                } else {
                    // If null → request fresh location
                    requestFreshLocation(result)
                }
            }
            .addOnFailureListener {
                result.success(null)
            }
    }

    private fun requestFreshLocation(result: MethodChannel.Result) {

        val locationRequest = LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY,
            1000
        )
            .setMaxUpdates(1)
            .build()

        fusedLocationClient.requestLocationUpdates(
            locationRequest,
            object : LocationCallback() {
                override fun onLocationResult(locationResult: LocationResult) {
                    val freshLocation = locationResult.lastLocation

                    if (freshLocation != null) {
                        result.success(
                            mapOf(
                                "latitude" to freshLocation.latitude,
                                "longitude" to freshLocation.longitude
                            )
                        )
                    } else {
                        result.success(null)
                    }

                    fusedLocationClient.removeLocationUpdates(this)
                }
            },
            Looper.getMainLooper()
        )
    }
}
