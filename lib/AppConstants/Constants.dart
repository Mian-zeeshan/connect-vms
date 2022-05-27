import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/cupertino.dart';

//font sizes
final labelSize = 15;
final buttonFontSize = 14;
final xHeadingFontSize = 24;
final xxHeadingFontSize = 36;
final headingFontSize = 20;
final titleFontSize = 18;
final labelFontSize = 15;
final descriptionFontSize = 14;
final smallFontSize = 14;
final xSmallFontSize = 10;

//font weights
final xBold = FontWeight.w900;
final bold = FontWeight.bold;
final normal = FontWeight.normal;
final light = FontWeight.w500;
final buttonFontWeight = FontWeight.w600;


//Route
final splashRoute = "/";

//Json Database
final currentUser = "User";
final allCarts = "AllCarts";
final allFavorites = "allFavorites";
final recentItems = "recentItems";
final databaseName = "databaseFromWeb";

final english = "en_US";
final arabic = "ar_AR";
final language = "language";
final pendingRequests = "pendingRequests";
final pendingRequestsExit = "pendingRequestsExit";

final imageTypeGate = "GatePass";
final imageTypeVehicle = "Vehicle";
final imageTypeVisitor = "Visitor";
final imageTypeIdCard = "Id Card";


final apiUrl = "http://vmsapi.connect-sol.com/";

var qrCode = "";
Uint8List? ipImageGlobal;

BluetoothDevice? savedDevice;
