import 'dart:async';
import 'dart:io';

import 'package:alwan_v_3/app_localization.dart';
import 'package:alwan_v_3/helper/api.dart';
import 'package:alwan_v_3/helper/app.dart';
import 'package:alwan_v_3/helper/global.dart';
import 'package:alwan_v_3/view/sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';


class ProfileController extends GetxController {

    RxBool loading = false.obs;
    var note = TextEditingController();

    requsetLastStatment(BuildContext context){
      if(Global.userId==-1){
        Get.offAll(()=>SignIn());
      }else{
        loading.value = true;
        Api.requestStatement("note", Global.userId).then((value) {
          loading.value = false;
          note.clear();
          if(value){
            App.mySnackBar(App_Localization.of(context).translate("req_state_succ_t"), App_Localization.of(context).translate("req_state_succ_d"));
          }else{
            App.mySnackBar(App_Localization.of(context).translate("oops_t"), App_Localization.of(context).translate("oops_d"));
          }
        });
      }
    }

    Future<File> loadPdf() async {
      Completer<File> completer = Completer();
      final url = Global.user!.financialState;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
      return completer.future;

    }
}