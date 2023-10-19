import UIKit
import Flutter
import Enx_CallKit_iOS
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    var callManager : EnxCallKit!
    var actionFlag : Bool = true
    var flutterChannel : FlutterMethodChannel!
    private var eventSink1: FlutterEventSink?
    private var reciveDeviceToken : String!
    var remoteNumber = "Caller"
    var dailerUUID = "UUID"
    var room_Id = "Room ID"
    //Check Premission
    private func getPrivacyAccess(){
        let vStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if(vStatus == AVAuthorizationStatus.notDetermined){
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            })
        }
        let aStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        if(aStatus == AVAuthorizationStatus.notDetermined){
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
            })
        }
    }
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink1 = events
        return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        // to do
        eventSink1 = nil
        return nil
    }
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let center = UNUserNotificationCenter.current()
      center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
          guard granted else { return }
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
      }
      getPrivacyAccess()
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      flutterChannel  = FlutterMethodChannel(name: "flutter.native/helper",
                                                    binaryMessenger: controller.binaryMessenger)
      flutterChannel.setMethodCallHandler({[weak self] (call: FlutterMethodCall , result : FlutterResult) -> Void in
          if call.method.caseInsensitiveCompare("needToken") == .orderedSame{
              self!.setMethodsForToken(result: result)
          }
      })

      GeneratedPluginRegistrant.register(with: self)
      callManager = EnxCallKit(self)
      let chargingChannel = FlutterEventChannel(name: "flutter.native/helperCallBacks",
                                                    binaryMessenger: controller.binaryMessenger)
          chargingChannel.setStreamHandler(self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    private func setMethodsForToken(result: FlutterResult){
        if let token = reciveDeviceToken{
            result(token)
        }
    }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
          let token = tokenParts.joined()
        print(token)
        reciveDeviceToken = token
    }
    override func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      
    }
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let remoteNum = (userInfo["remotePhoneNumber"] as? String){
            remoteNumber = remoteNum
        }
        if let uuidString = (userInfo["UUID"] as? String)  , let handle = (userInfo["message"] as? String)  {
            dailerUUID = uuidString;
            if(handle == "call-initiated"){
                let caller = "Incoming Call - " + remoteNumber
                clickToStartCAll(caller)
            }
            else if(handle == "call-invited"){
                let caller = "Invite Call - " + remoteNumber
                if let roomID = (userInfo["roomId"] as? String){
                    room_Id = roomID
                }
                clickToStartCAll(caller)
            }
            else if(handle == "call start"){
                if let token = (userInfo["roomToken"] as? String)  , let roomID = (userInfo["roomId"] as? String){
                    room_Id = roomID
                    guard let eventSink = eventSink1 else {
                        return
                    }
                    let callInfo : [String : String] = ["roomToken" : token , "roomId" : room_Id , "remoteNumber" :remoteNumber]
                    eventSink("callstart -Body:\(callInfo)")
                }
                clickToStartCAll("CallStarted" , isStrat: false)
            }
            else if(handle == "call rejected"){
                clickToStartCAll("Rejected" , isStrat: false)
            }
           else if(handle == "end call"){
               guard let eventSink = eventSink1 else {
                   return
               }
               eventSink("endsall")
               clickToStartCAll("endsall" , isStrat: false)
            }
        }
    }
    // call this for showing the UICalling
    func clickToStartCAll( _ withDetails: String, isStrat : Bool = true){
        if(isStrat){
            let backGroundTaskIndet = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            callManager.reportIncomingCall(uuid: UUID(), callerName: withDetails, hasVideo: true){ _ in
                UIApplication.shared.endBackgroundTask(backGroundTaskIndet)
            }
        }
        else{
            callManager.endCall()
        }
    }
}
extension AppDelegate : EnxCallStateDelegate{
    func callAnswer(){
        guard let eventSink = eventSink1 else {
             return
           }
        let body = ["remoteNumber" :remoteNumber]
        eventSink("callAnswer -Body:\(body)")
        print("callAnswer -Body:\(["remoteNumber" :remoteNumber])")
    }
    func callReject(){
        guard let eventSink = eventSink1 else {
             return
           }
        let body = ["remoteNumber" :remoteNumber]
        eventSink("callReject -Body:\(body)")
    }
    func callTimeOut(){
        guard let eventSink = eventSink1 else {
             return
           }
        let body = ["remoteNumber" :remoteNumber]
        eventSink("callTimeOut -Body:\(body)")
    }
    func callEnd(){
        guard let eventSink = eventSink1 else {
             return
           }
        let body = ["remoteNumber" :remoteNumber]
        eventSink("callEnd -Body:\(body)")
    }
    func callHold(){
        guard let eventSink = eventSink1 else {
             return
           }
        let body = ["remoteNumber" :remoteNumber]
        eventSink("callHold -Body:\(body)")
    }
}
