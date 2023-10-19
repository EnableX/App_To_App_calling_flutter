import 'dart:convert';

import 'package:enx_uikit_flutter/buttons/custom_button.dart';
import 'package:enx_uikit_flutter/enx_uikit_flutter.dart';
import 'package:enx_uikit_flutter/utilities/color.dart';
import 'package:enx_uikit_flutter/utilities/enx_setting.dart';
import 'package:enxcalling/controllers/call_controller.dart';
import 'package:enxcalling/controllers/user_list_controller.dart';
import 'package:enxcalling/screens/user_list_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CallScreen extends StatelessWidget{
   const CallScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CallController obj;
    bool isRegisterCall = Get.isRegistered<UserListController>();
    if(isRegisterCall){
      obj = Get.find<CallController>();
    }else{
      obj = Get.put(CallController());
    }

    UserListController user;
    bool isRegister = Get.isRegistered<UserListController>();
    if(isRegister){
      user = Get.find<UserListController>();
    }else{
      user = Get.put(UserListController());
    }

    var pos= user.position;
   print("index ${pos}");

    var setting = EnxSetting.instance;

    Set<EnxRequiredEventsOption> enxRequired= <EnxRequiredEventsOption>{};
    enxRequired.addAll([EnxRequiredEventsOption.audio,EnxRequiredEventsOption.video,EnxRequiredEventsOption.cameraSwitch,EnxRequiredEventsOption.audioSwitch,EnxRequiredEventsOption.disconnect]);
    setting.configureRequiredEventList(enxRequired);
    setting.configureParticipantList(ParticipantListOption.audio);
    setting.configureParticipantList(ParticipantListOption.video);
     setting.configureParticipantList(ParticipantListOption.disconnect);
     setting.isPreScreening(false);

    return Scaffold(
      backgroundColor: Colors.white,
      body:Obx(()=>
   obj.token.isEmpty?
   Padding(
     padding: const EdgeInsets.all(20.0),
     child: SafeArea(
       child: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
              Image.asset("assets/images/user_profile.png") ,
             const Text(
               "",
               style:TextStyle(color: Colors.black54,fontSize: 25,fontWeight: FontWeight.bold)
             ),
             const Padding(
               padding:  EdgeInsets.all(8.0),
               child: Text("Connecting.....",style: TextStyle(color: Colors.black54,fontSize: 20,fontWeight: FontWeight.normal),),
             ) ,
             Spacer(flex: 5,),

             Spacer(),
             CustomMaterialButton(
      onPressed: () => {

        obj.endCall()
      },
      shape: const CircleBorder(),
      elevation: 2.0,
      fillColor: CustomColors.themeColor,
      child:  const Icon(Icons.call_end, color: Colors.white, size: 20),


    )

           ],
         ),
       ),
     ),
   ):SafeArea(
      child: EnxVideoView(
      token: obj.token.value,
        embedUrl: "",
        connectError: (Map<dynamic, dynamic> map) {
          obj.token.value='';
          Fluttertoast.showToast(
              msg: jsonEncode(map),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

         Get.delete<CallController>();
          Get.offAll(() => const UserListScreen());
        },
        disconnect: (Map<dynamic, dynamic> map) {
        obj.token.value='';
          Fluttertoast.showToast(
              msg: "${map['msg']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        Get.delete<CallController>();
        Get.offAll(() => const UserListScreen());

        },
      ),
    ),)
    );
  }

}
