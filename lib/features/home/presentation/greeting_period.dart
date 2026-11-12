String greetingFor(DateTime time) {
  final hour = time.hour;
  if (hour < 11) return 'pagi';
  if (hour < 15) return 'siang';
  if (hour < 18) return 'sore';
  return 'malam';
}
