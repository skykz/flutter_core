// import 'package:location/location.dart';

// /// запрашивает разрешение
// /// [isGrantedPermission] - флаг для проверки дано ли разрешение
// /// [locationData] - данные по текущему местоположению
// /// [resultPermission] - резултат
// /// [awaiting] - действие во время ожидания принятия решения при диалоге
// void requestPermission({
//   Function(
//     bool isGrantedPermission,
//     LocationData locationData,
//   )
//       resultPermission,
//   Function() awaiting,
// }) async {
//   Location location = new Location();
//   LocationData locationData;
//   PermissionStatus hasPermission;

//   if (awaiting != null) awaiting?.call();
//   hasPermission = await location?.hasPermission();
//   if (hasPermission == PermissionStatus?.denied) {
//     hasPermission = await location?.requestPermission();
//   }
//   if (hasPermission != PermissionStatus?.denied) {
//     locationData = await location?.getLocation();
//   }
//   resultPermission.call(
//     hasPermission == PermissionStatus?.granted,
//     locationData,
//   );
// }
