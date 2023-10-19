package com.enablex.enxcalling

import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import com.enxcallkit.observer.EnxCallKitStateObserver
import com.enxcallkit.view.EnxCallKitView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import java.util.logging.StreamHandler


class MainActivity: FlutterActivity() {
    private val channel = "flutter.native/helper"
    private val eventHandlerChannel = "flutter.native/helperCallBacks"
    private var eventsL: EventSink? = null
     var callKitView:EnxCallKitView?=null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //initCallKit()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        intent.data
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor, eventHandlerChannel).setStreamHandler(
            object : StreamHandler(), EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventSink?) {

                    if (events != null) {
                        eventsL=events
                        events.success(arguments);
                    }

                }

                override fun onCancel(arguments: Any?) {
                    eventsL=null
                }
            }
        )
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "initCallKit") {
                initCallKit()


            }else if(call.method=="callReject") {
                rejectCall()
              //  result.success(batteryLevel)
            }else if(call.method=="callEnd") {
              //  result.success(batteryLevel)
            }else if(call.method=="callHold") {
               // result.success(batteryLevel)
            }else if(call.method=="callReject") {
               // result.success(batteryLevel)
            }else if(call.method=="callTimeOut") {
               // result.success(batteryLevel)
            }else {
                result.notImplemented()
            }
        }
    }


   var enxCallKitStateObserver=  object : EnxCallKitStateObserver {
           override fun callAnswer() {
               eventsL?.success("callAnswer")

           }

       override fun callReject() {
           eventsL?.success("callReject")
       }

       override fun callTimeOut() {
               eventsL?.success("callTimeOut")
           }
       }




    private fun initCallKit() {
        try {
            callKitView = EnxCallKitView.getInstance(
                this, "EnxCalling",
                R.mipmap.ic_launcher, enxCallKitStateObserver
            )

        } catch (exception: Exception) {
            exception.printStackTrace()
        }
    }
         fun rejectCall() {
            try{
              if(callKitView!=null) {
                 EnxCallKitView.stopService(this)
              }

            }catch(exception:Exception){
                exception.printStackTrace()
            }
}






}
