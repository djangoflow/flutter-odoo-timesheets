class RecordExceptionUtils {
  static String? extractRecordModel(String input) {
    final modelRegex = RegExp(r'(\w+\.\w+)');
    final modelMatch = modelRegex.firstMatch(input);
    if (modelMatch != null) {
      return modelMatch.group(1);
    } else {
      return null;
    }
  }

  static String? extractRecordId(String input) {
    final idRegex = RegExp(r'\((\d+),');
    final idMatch = idRegex.firstMatch(input);
    if (idMatch != null) {
      return idMatch.group(1)!;
    } else {
      return null;
    }
  }
}
