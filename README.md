#Introduction:#
The "App to App Calling with Flutter" is a sample application that demonstrates the capabilities of audio and video calling using the EnableX infrastructure, Flutter UIkit, iOS Callkit, and UIKit. This sample app serves as a practical resource for developers interested in exploring real-time audio and video communication on both iOS and Android platforms using the Flutter framework.

Key Features:

* Establishing P2P Calls: This sample app provides a comprehensive guide on how to set up peer-to-peer calls between one or more users, even when the app is in the background or terminated state.

* Utilized Services:
    * Remote Push Notification: To inform end-users about incoming calls.
    * Callkit for iOS: To seamlessly launch the telecom UI, allowing users to accept or reject calls.
    * Flutter UIkit: To facilitate the connection of two or more users in an EnableX Room and enable the publishing of their audio and video streams.

Main Functionalities:

With this sample app, you can effortlessly:
* Create a Virtual Room: Using the REST video API, you can easily set up a virtual room.
* Retrieve Room Credentials: Gain access to the necessary credentials, such as the Room ID.
* Join Virtual Room: You can join the virtual room either as a moderator or a participant, ensuring secure connections for all users.

Additional Features:

For Participants and Moderators:
* Mute Self-Audio: You have the option to mute your own audio during the call.
* Mute Self-Video: Similarly, you can mute your own video stream if needed.
* Switch Camera: The app allows you to switch between front and rear cameras during a call.
* Switch Audio Device: You can seamlessly switch between audio input and output devices as per your requirements.

Participant List:
* Disconnect Call: Participants can choose to disconnect from the call when necessary.

For Moderators Only:
* Disconnect Call: Moderators have the authority to disconnect the entire call.
* Mute Participant-Audio: Moderators can mute the audio of specific participants.
* Mute Participant-Video: Similarly, moderators can also mute the video streams of specific participants.
* Drop Participant from Room: If needed, moderators have the capability to remove participants from the room.

Conclusion:
The "App to App Calling with Flutter" sample application is a powerful tool for understanding and implementing audio and video calling features within your mobile app. It leverages the latest technologies and services to ensure a smooth and secure real-time communication experience for both participants and moderators.

For any inquiries or further assistance, please do not hesitate to contact our support team.

Note: Ensure that you adhere to the necessary permissions and guidelines for using audio and video capabilities within your application, especially in regard to user privacy and data security.


> For more information, pls visit our Developer Center
    https://www.enablex.io/developer/video/solutions/video-ui-kit/flutter-video-ui-kit/

## 1. Get started

### 1.1 Prerequisites

#### 1.1.1 App ID and App Key 

You would need API Credentials to access EnableX platform. To do that, simply create an account with us. It’s absolutely free!

* Create an account with EnableX - https://portal.enablex.io/cpaas/trial-sign-up/
* Create your Project
* Get your App ID and App Key delivered to your email

* The Above setup is only for getting required room and token from EnableX Server.
* Also This sample app will only demonstrate, How to make app to app call. EnableX Will not provide any push service for notification. App User need to integrate the notification service and handle the notificateion based on their business logics.

#### 1.1.2 Requirement
*Flutter Set-up
* Remote Notification set-up (based on business requirements)
* iOS Deployment Target: 13.0 or higher
* Xcode Version: 10.0 or higher
* Android Studio

#### 1.1.3 Application Server

An Application Server is required for your iOS App to communicate with EnableX. We have different variants of the Application Server Sample Code. Pick the one in your preferred language and follow the instructions given in the README.md file of the respective Repository.

* NodeJS: https://github.com/EnableX/Video-Conferencing-Open-Source-Web-Application-Sample.git 
* PHP: https://github.com/EnableX/Group-Video-Call-Conferencing-Sample-Application-in-PHP

Note the following:
•    You need to use App ID and App Key to run this Service.
•    Your Client EndPoint needs to connect to this Service to create a Virtual Room and Create a Token to join the session.
•    Application Server is created using [EnableX Server API](https://www.enablex.io/developer/video-api/server-api) while Rest API Service helps in provisioning, session access and post-session reporting.

If you would like to test the quality of EnableX video call before setting up your own application server,  you can run the test on our pre-configured environment. Refer to point 2 for more details on this.

# work through

In this sample app, we have explained how to communicate from flutter to native and vice versa.

## Notify events from flutter to native
Create a method channel which is responsible for sending events from Flutter to the native
**How to do in flutter
static const platform = MethodChannel('flutter.native/helper');
Sent event to iOS/Android
Future<void> _getInformation() async {
    try {
    var result = await platform.invokeMethod('Event NAme');
      tokenValue = result;
    } on PlatformException catch (e) {
      tokenValue = "Failed to get battery level: '${e.message}'.";
    }
    print(tokenValue);
  }**
  
**How to do in iOS
*In AppDelegate.swift class 
At didFinishLaunchingWithOptions method
          var flutterChannel  = FlutterMethodChannel(name: "flutter.native/helper",
                                                    binaryMessenger: controller.binaryMessenger)
Register the event listener from the flutter 
        flutterChannel.setMethodCallHandler({[weak self] (call: FlutterMethodCall , result : FlutterResult) -> Void in
          if call.method.caseInsensitiveCompare("Your Event Name which you have set in flutter") == .orderedSame{
              //Take Action in iOS Native
          }
      })*

** How to do in Android
*In Main Activity class 
    private val channel = "flutter.native/helper"
    //Override methods
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
        }
    }
## Now Notify events from native to native
Create a method channel which is responsible for sending events from native to Flutter
**How to do in the flutter
    static const EventChannel eventChannel = EventChannel('flutter.native/helperCallBacks');
    void _onEvent(Object event) {
    print("Test Callback$event");
  }
**How to do in iOS
*In AppDelegate.swift class 
    private var eventSink: FlutterEventSink?
At didFinishLaunchingWithOptions method
                let chargingChannel = FlutterEventChannel(name: "flutter.native/helperCallBacks",
                                                    binaryMessenger: controller.binaryMessenger)
          chargingChannel.setStreamHandler(self) 
*Handel the listener from Flutter to iOS
//Update the eventSink on the listener

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink1 = events
        return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        // to do
        eventSink1 = nil
        return nil
    }
   //Send event back to flutter
           eventSink("callAnswer")       

** How to do in Android
*In Main Activity class 
    private val eventHandlerChannel = "flutter.native/helperCallBacks"
    private var eventsL: EventSink? = null
    //Override methods
    var enxCallKitStateObserver=  object : EnxCallKitStateObserver {
                   eventsL?.success("callAnswer")
           }


