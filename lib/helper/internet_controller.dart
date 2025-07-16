import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';

class InternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    print("InternetController initialized");
    _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen(NetStatus);
  }

/*   Future<void> _checkInitialConnection() async {
    print("Checking initial connection");
    ConnectivityResult result = await _connectivity.checkConnectivity();
    print("Initial connection status: $result");
    NetStatus(result);
  }
 */

Future<void> _checkInitialConnection() async {
  print("Checking initial connection");
  List<ConnectivityResult> results = await _connectivity.checkConnectivity();
  print("Initial connection status: $results");
  NetStatus(results);
}
 /*  void NetStatus(ConnectivityResult result) {
    print("Network status changed: $result");
    if (result == ConnectivityResult.none) {
      print("No internet connection - attempting to show snackbar");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("Post frame callback - showing snackbar");
        Get.rawSnackbar(
          titleText: SizedBox(
              width: double.infinity,
              height: Get.size.height / 1.1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: NoInternetConnection(),
              )),
          messageText: Container(),
          backgroundColor: Colors.transparent,
          isDismissible: false,
          duration: const Duration(days: 1),
        );
      });
    } else {
      if (Get.isSnackbarOpen) {
        print("Closing snackbar");
        Get.closeCurrentSnackbar();
      }
    }
  }

 */


void NetStatus(List<ConnectivityResult> results) {
  final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
  print("Network status changed: $result");
  
  if (result == ConnectivityResult.none) {
    print("No internet connection - attempting to show snackbar");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Post frame callback - showing snackbar");
      Get.rawSnackbar(
        borderRadius:8.0,
        titleText: SizedBox(
          width: double.infinity,
          height: Get.size.height / 1.1,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: const NoInternetConnection(), // Ensure this widget is created
          )),
        messageText: Container(),
        backgroundColor: Colors.transparent,
        isDismissible: false,
        duration: const Duration(days: 1),
      );
    });
  } else {
    if (Get.isSnackbarOpen) {
      print("Closing snackbar");
      Get.closeCurrentSnackbar();
    }
  }
}



}

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius:BorderRadius.circular(8.0),
       color: Colors.red,),
     
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded,color: whitecolor,),
          const Text(
            "No Internet Connection",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
