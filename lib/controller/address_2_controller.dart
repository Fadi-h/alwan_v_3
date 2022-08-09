import 'package:alwan_v_3/app_localization.dart';
import 'package:alwan_v_3/controller/order_controller.dart';
import 'package:alwan_v_3/helper/api.dart';
import 'package:alwan_v_3/helper/app.dart';
import 'package:alwan_v_3/helper/global.dart';
import 'package:alwan_v_3/helper/myTheme.dart';
import 'package:alwan_v_3/helper/store.dart';
import 'package:alwan_v_3/model/address.dart';
import 'package:alwan_v_3/view/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController_2 extends GetxController {



  TextEditingController? nick_name;
  TextEditingController? street_name;
  TextEditingController? building;
  TextEditingController? floor;
  TextEditingController? flat;
  TextEditingController? ad_desc;
  TextEditingController? phone;

  int orderId = -1;

  RxInt emirateIndex = (-1).obs;
  RxBool loading = false.obs;
  RxBool validate = false.obs;

  List<String> emirateList = ['Dubai','Abo Dhabi','Ajman','Ras Al Khaimah','Sharjah','Umm Al Quwin','Dubai Eye'];

  OrderController orderController = Get.find();

  @override
  void onInit() {
    super.onInit();
    // clearTextField();
    // Global.getUserInformation();
    // nick_name = TextEditingController(text: Global.nick_name);
    // street_name = TextEditingController(text: Global.street_name);
    // building = TextEditingController(text: Global.building);
    // floor = TextEditingController(text: Global.floor);
    // flat = TextEditingController(text: Global.flat);
    // ad_desc = TextEditingController(text: Global.ad_desc);
    // phone = TextEditingController(text: Global.phone);
  }

  saveAddress() async {
    // loading.value = true;
    Address address = Address(nickName: nick_name!.text, streetName: street_name!.text,
        building: building!.text, floor: floor!.text, flat: flat!.text,
        adDesc: ad_desc!.text, phone: phone!.text);
    Store.saveAddress(address);
    Store.loadAddress();
    Get.snackbar(
        'Done!',
        'Address saved successfully',
        margin: EdgeInsets.only(top: 30,left: 25,right: 25),
        backgroundColor: MyTheme.isDarkTheme.value ? Colors.grey.withOpacity(0.5) : Colors.black.withOpacity(0.5),
        colorText: Colors.white
    );

  }

  clearTextField (){
    nick_name!.clear();
    street_name!.clear();
    building!.clear();
    floor!.clear();
    flat!.clear();
    ad_desc!.clear();
    phone!.clear();
  }

  requsetShipping(BuildContext context){

    if(Global.userId==-1){
      Get.offAll(()=>SignIn());
    }else{
      if(nick_name!.text.isEmpty||street_name!.text.isEmpty||building!.text.isEmpty||
          floor!.text.isEmpty||flat!.text.isEmpty||phone!.text.isEmpty){
        validate.value = true;
      }else{
        validate.value = false;
        loading.value = true;
        Api.requestShipping(nick_name!.text, street_name!.text, building!.text, floor!.text, flat!.text, ad_desc!.text, phone!.text, orderId).then((value) {
          loading.value = false;
          print("loading.value");
          print(value);
          orderController.getOrderData();
          if(value){
            App.mySnackBar(App_Localization.of(context).translate("req_shipping_succ_t"), App_Localization.of(context).translate("req_shipping_succ_d"));
          }else{
            App.mySnackBar(App_Localization.of(context).translate("oops_t"), App_Localization.of(context).translate("oops_d"));
          }
          Get.back();
        });
      }

    }
  }

}