package com.example.jjm_wqmis

import android.Manifest
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example/location_permission"
    private lateinit var locationManager: LocationManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestPermission" -> {
                    val permissionGranted = requestLocationPermission()
                    result.success(permissionGranted)
                }
                "getLocation" -> {
                    val location = getCurrentLocation()
                    if (location != null) {
                        result.success(mapOf(
                            "latitude" to location.latitude,
                            "longitude" to location.longitude
                        ))
                    } else {
                        result.error("LOCATION_ERROR", "Location not available", null)
                    }
                }
                "getVersionName"->{
                    try {
                        val pInfo = applicationContext.packageManager.getPackageInfo(applicationContext.packageName, 0)
                        val version = pInfo.versionName
                        result.success(version)
                    } catch (e: PackageManager.NameNotFoundException) {
                        result.error("UNAVAILABLE", "Version name not available.", null)
                    }
                }
                "getSecretKey"->{
                    result.success(getSecretKey())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getSecretKey(): String {
        return "8080808080808080" // 🔒 Secret key stored natively
    }
    private fun requestLocationPermission(): Boolean {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), 100)
            return false
        }
        return true
    }

    private fun getCurrentLocation(): Location? {
        locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
        val providers = locationManager.getProviders(true)

        var bestLocation: Location? = null
        for (provider in providers) {
            val l = locationManager.getLastKnownLocation(provider) ?: continue
            if (bestLocation == null || l.accuracy < bestLocation.accuracy) {
                bestLocation = l
            }
        }
        return bestLocation
    }
}