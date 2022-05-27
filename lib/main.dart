import 'package:connect_vms/GetxController/AppbarController.dart';
import 'package:connect_vms/GetxController/ThemeController.dart';
import 'package:connect_vms/GetxController/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'AppConstants/Constants.dart';
import 'GetxController/PendingRequestsController.dart';
import 'Views/intro_screens/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ThemeController());
  Get.put(LocaleController());
  Get.put(AppbarController());
  Get.put(PendingRequestsController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return ScreenUtilInit(
      designSize: Size(495, 880),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,_) => GetMaterialApp(
        transitionDuration: Duration(microseconds: 300),
        //translations: WorldLanguage(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'AR'),
        ],
        locale: const Locale('en', 'US'),
        getPages: [
          GetPage(name: splashRoute, page: () => SplashScreen() ,),
        ],
        title: 'Connect VMS',
        initialRoute: splashRoute,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
        ),
        builder: (context, child) {
          return GetBuilder<LocaleController>(id: "0", builder: (localeController){
            child = EasyLoading.init()(context,child);
            return Directionality(
              textDirection: localeController.locale == english ? TextDirection.ltr :TextDirection.rtl,
              child: child!,
            );
          });
        },
      ),
    );
  }
}
