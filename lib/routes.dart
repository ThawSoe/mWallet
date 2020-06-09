import 'package:flutter/material.dart';
import 'package:nsb/pages/Contact.dart';
import 'package:nsb/pages/LocationDetail.dart';
import 'package:nsb/pages/Scan/GenerateQR/QR.dart';
import 'package:nsb/pages/Scan/GenerateQR/QRConfirm.dart';
import 'package:nsb/pages/Scan/ScanPayment.dart';
import 'package:nsb/pages/Scan/ScanPaymentConfirm.dart';
import 'package:nsb/pages/Scan/ScanPaymentSuccess.dart';
import 'package:nsb/pages/Transaction/TransitionMain.dart';
import 'package:nsb/pages/Transfer/transferconfirm.dart';
import 'package:nsb/pages/Transfer/transfersuccess.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/pages/locationPage.dart';
import 'package:nsb/constants/rout_path.dart' as routes;
import 'package:nsb/pages/newLoginPage.dart';
import 'package:nsb/pages/newOtpPage.dart';
import 'package:nsb/pages/signUp.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case routes.NewLoginPageRoute:
         return MaterialPageRoute(builder: (context) => NewLoginPage());
    case routes.NewOtpPageRoute:
         return MaterialPageRoute(builder: (context) => NewOtpPage());
    case routes.LocationPageRoute:
      return MaterialPageRoute(builder: (context) => locationPage());
    case routes.ExchangeRatePageRoute:
      return MaterialPageRoute(builder: (context) => SignUpPage());    
    case routes.ContactPageRoute:
      return MaterialPageRoute(builder: (context) =>Contact());
    case routes.QRPageRoute:
      return MaterialPageRoute(builder: (context) =>QRPage());
    case routes.QRConfirmPageRoute:
      return MaterialPageRoute(builder: (context) =>QRConfirm());
     case routes.TransferConfirmPageRoute:
      return MaterialPageRoute(builder: (context) =>TransferConfirmPage());
    case routes.TransferSuccessPageRoute:
      return MaterialPageRoute(builder: (context) =>TransferSuccessPage());
    case routes.LocationDetailPageRoute:
      return MaterialPageRoute(builder: (context) =>LocationDetail());
      case routes.TransitionMainPageRoute:
    return MaterialPageRoute(builder: (context) =>TransitionMain());
      case routes.WalletPageRoute:
      return MaterialPageRoute(builder: (context) =>WalletPage());
    case routes.ScanPaymentPageRoute:
      return MaterialPageRoute(builder: (context) =>ScanPayment());
    case routes.ScanPaymentConfirmPageRoute:
      return MaterialPageRoute(builder: (context) =>ScanPaymentConfirm());
    case routes.ScanPaymentSuccessPageRoute:
      return MaterialPageRoute(builder: (context) =>ScanPaymentSuccess());
          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text('No path for ${settings.name}'),
                ),
              ),
            );
        }
      }
