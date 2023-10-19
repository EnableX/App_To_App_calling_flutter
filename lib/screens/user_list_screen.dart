import 'dart:convert';
import 'package:enxcalling/controllers/user_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/call_controller.dart';
import '../data/notification_response.dart';

class UserListScreen extends StatelessWidget{
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CallController enxController;
    UserListController obj;
    bool isRegisterUser = Get.isRegistered<UserListController>();
    if(isRegisterUser){
      obj = Get.find<UserListController>();
    }else{
      obj = Get.put(UserListController());
    }
    bool isRegister = Get.isRegistered<CallController>();
  if(isRegister){
   enxController = Get.find<CallController>();
}else{
       enxController = Get.put(CallController());
    }

    if(Get.arguments!=null) {
      var notificationdata = Get.arguments;
      var data=json.decode(notificationdata);
      obj.data.value=data;
      var notificationData=  NotificationResponse.fromJson(data);
      enxController.notificationData.value=notificationData;
      enxController.token.value=notificationData.roomToken!;
    }
    if(  enxController.notificationData.value?.message=='call-initiated'){
      obj.initCallKit();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'User List ',
        ),
      ),
      body:Obx(()=>obj.deviceContacts.isEmpty? const Center(child: Text("No Contact found..")):
      ListView.builder(itemCount: obj.deviceContacts.length, itemBuilder: (context, i) =>
          Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            child: GestureDetector(
              onTap: (){
                obj.callStartApi(i,1);
              },
              child: ListTile(
                leading: const Icon(Icons.person),
                trailing: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Wrap(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.video_call),
                    ),
                  ],),
                ),
                title: Text("${obj.deviceContacts[i].name}"),subtitle: Text("${obj.deviceContacts[i].phoneNumber}"),),
            ),

          ))),
    );
  }

}