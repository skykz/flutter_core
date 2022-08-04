import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:intl/intl.dart';

/// Конвертируем дату из одного формата в другой
/// [currentDate] currentDate дата для которой требуеться конвертация
/// [currentDatePattern] в каком формате сейчас дата
/// [newDatePattern] в какой формат нужно перевести дату
String convertDate(
  String currentDate,
  String currentDatePattern,
  String newDatePattern,
) {
  try {
    DateTime currentDateTime = DateTime.parse(currentDate);
    final newDateTime = DateFormat(newDatePattern).format(currentDateTime);
    return newDateTime;
  } catch (ex) {
    return CoreConstant.empty;
  }
}

/// Высчитываем остаток времени из текущего и переданного в параметре время до окончания
/// [endDate] дата для высчитавания
String timeCalculate(String endDate) {
  DateTime currentDateTime = DateTime.now();
  final date = DateTime.parse(endDate).difference(currentDateTime);
  final hours = date.inHours.abs();
  final minutes = ((date.inSeconds / 60) % 60).floor().abs();
  final seconds = (date.inSeconds % 60).abs();

  final convertMinute = minutes.toString().length == 1 ? "0$minutes" : minutes;
  final convertSeconds = seconds.toString().length == 1 ? "0$seconds" : seconds;
  return "$hours:$convertMinute:$convertSeconds";
}

bool compareTwoDate(String oneDate, String twoDate, String pattern) {
  DateTime oneDateDateTime = DateFormat(pattern).parse(oneDate);
  DateTime twoDateDateTime = DateFormat(pattern).parse(twoDate);
  DateTime currentDateTime = DateTime.now();

  final currentHour = currentDateTime.hour;
  final currentMinute = currentDateTime.minute;

  if (currentHour >= oneDateDateTime.hour &&
      currentHour <= twoDateDateTime.hour) {
    return true;
  }

  if (currentMinute >= oneDateDateTime.minute &&
      currentMinute <= twoDateDateTime.minute) {
    return true;
  }

  return false;
}
