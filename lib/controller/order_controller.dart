import 'package:alwan_v_3/helper/api.dart';
import 'package:alwan_v_3/helper/global.dart';
import 'package:alwan_v_3/model/order.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class OrderController extends GetxController{

  RxList <Order> myOrders = <Order>[].obs;
  RxBool loading = false.obs;
  RxBool fake = false.obs;


  @override
  void onInit() {
    super.onInit();
    getOrderData();
  }


  getOrderData() async {
    loading.value == true;
    Api.checkInternet().then((internet){
      if(internet){
        Api.getCustomerOrder(Global.userId.toString()).then((value){
          if(value.isNotEmpty){
            print('done');
            myOrders.value = value;
            loading.value = false;
          }else{
            print('no orders');
            loading.value = false;
          }
        });
      }else{
        print('no internet');
        loading.value = false;
      }
    });
  }

  calculateTime(index){
    DateTime now = DateTime.now();
    int month = myOrders[index].deadline.month - now.month;
    int day = myOrders[index].deadline.day - now.day;
    int hour =  24 - now.hour;

    if(myOrders[index].deadline.isAfter(now)){
      myOrders[index].ready.value = true;
      print(myOrders[index].ready.value);
    }
    var dateList = [];
    dateList.add(month);
    dateList.add(day);
    dateList.add(hour);

    return dateList;
  }

  convertTime(String time){
    var timeArray = time.split('T');
    var dateTime = DateFormat('yyyy-MM-dd').parse(timeArray.first);
    print(DateFormat('MMM dd yyyy').format(dateTime));
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  setOrderState(index){
    switch(myOrders[index].state){
      case 1:
        myOrders[index].orderState = 'In progress';
        break;
      case 2:
        myOrders[index].orderState = 'Waiting for final payment';
        break;
      case 3:
        myOrders[index].orderState = 'Ready';
        break;
      case 4:
        myOrders[index].orderState = 'Deliver';
        break;
    }
  }

}