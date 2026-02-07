package com.example.duskspendr

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.provider.Settings
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "dev.duskspendr/sms"
    private val SMS_PERMISSION_CODE = 101
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkSmsPermission" -> {
                    result.success(getPermissionStatus())
                }
                "requestSmsPermission" -> {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) == PackageManager.PERMISSION_GRANTED) {
                        result.success("granted")
                    } else {
                        pendingResult = result
                        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_SMS, Manifest.permission.RECEIVE_SMS), SMS_PERMISSION_CODE)
                    }
                }
                "readSmsInbox" -> {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) == PackageManager.PERMISSION_GRANTED) {
                         Thread {
                             try {
                                 val since = call.argument<Long>("since")?.toLong()
                                 val senderFilter = call.argument<String>("senderFilter")
                                 val maxCount = call.argument<Int>("maxCount") ?: 100
                                 val messages = readSms(since, senderFilter, maxCount)
                                 runOnUiThread { result.success(messages) }
                             } catch (e: Exception) {
                                 runOnUiThread { result.error("READ_ERROR", e.message, null) }
                             }
                         }.start()
                    } else {
                        result.error("PERMISSION_DENIED", "SMS permission not granted", null)
                    }
                }
                "getFinancialSmsCount" -> {
                     if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) == PackageManager.PERMISSION_GRANTED) {
                         val since = call.argument<Long>("since")?.toLong()
                         val count = countSms(since)
                         result.success(count)
                     } else {
                         result.success(0)
                     }
                }
                "openAppSettings" -> {
                    openAppSettings()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == SMS_PERMISSION_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                pendingResult?.success("granted")
            } else {
                if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.READ_SMS)) {
                     pendingResult?.success("denied")
                } else {
                     pendingResult?.success("permanentlyDenied")
                }
            }
            pendingResult = null
        }
    }

    private fun getPermissionStatus(): String {
        return if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) == PackageManager.PERMISSION_GRANTED) {
            "granted"
        } else {
            "denied"
        }
    }

    private fun openAppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        val uri = Uri.fromParts("package", packageName, null)
        intent.data = uri
        startActivity(intent)
    }

    private fun readSms(since: Long?, senderFilter: String?, maxCount: Int): List<Map<String, Any>> {
        val messages = mutableListOf<Map<String, Any>>()
        val uri = Uri.parse("content://sms/inbox")
        val projection = arrayOf("_id", "address", "body", "date", "read")

        var selection: String? = null
        var selectionArgs: Array<String>? = null

        if (since != null) {
            selection = "date > ?"
            selectionArgs = arrayOf(since.toString())
        }

        val sortOrder = "date DESC"

        val cursor: Cursor? = contentResolver.query(uri, projection, selection, selectionArgs, sortOrder)

        cursor?.use {
            val idIndex = it.getColumnIndex("_id")
            val addressIndex = it.getColumnIndex("address")
            val bodyIndex = it.getColumnIndex("body")
            val dateIndex = it.getColumnIndex("date")
            val readIndex = it.getColumnIndex("read")

            while (it.moveToNext() && messages.size < maxCount) {
                val address = it.getString(addressIndex)

                // Filter by sender if needed
                if (senderFilter != null) {
                     try {
                         if (!Regex(senderFilter).containsMatchIn(address)) {
                             continue
                         }
                     } catch (e: Exception) {
                         // Ignore invalid regex
                     }
                }

                val map = mapOf(
                    "id" to it.getString(idIndex),
                    "sender" to address,
                    "body" to it.getString(bodyIndex),
                    "timestamp" to it.getLong(dateIndex),
                    "isRead" to (it.getInt(readIndex) == 1)
                )
                messages.add(map)
            }
        }
        return messages
    }

    private fun countSms(since: Long?): Int {
         val uri = Uri.parse("content://sms/inbox")
         val projection = arrayOf("count(_id)")
         var selection: String? = null
         var selectionArgs: Array<String>? = null

         if (since != null) {
            selection = "date > ?"
            selectionArgs = arrayOf(since.toString())
        }

        val cursor = contentResolver.query(uri, projection, selection, selectionArgs, null)
        cursor?.use {
            if (it.moveToFirst()) {
                return it.getInt(0)
            }
        }
        return 0
    }
}
