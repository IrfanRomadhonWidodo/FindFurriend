// app/routes/app_routes.dart
import 'package:get/get.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/slider_view.dart';
import '../views/home_view.dart';
import '../views/grooming/grooming_view.dart';
import '../views/grooming/payment_view.dart';
import '../views/training/training_view.dart';
import '../views/boarding/boarding_view.dart';
import '../views/boarding/boarding_payment_view.dart'; // Tambahkan import ini
import '../views/daycare/daycare_view.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: '/', page: () => SliderView()),
    GetPage(name: '/login', page: () => LoginView()),
    GetPage(name: '/register', page: () => RegisterView()),
    GetPage(name: '/home', page: () => HomeView()),
    GetPage(name: '/grooming', page: () => GroomingView()),
    GetPage(name: '/upload-payment', page: () => PaymentView()),
    GetPage(name: '/training', page: () => TrainingView()),
    GetPage(name: '/boarding', page: () => BoardingView()),
    GetPage(name: '/boarding-payment', page: () => BoardingPaymentView()),
    GetPage(name: '/daycare', page: () => DaycareView()),
  ];
}
