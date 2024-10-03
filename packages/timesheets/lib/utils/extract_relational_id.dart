int? extractRelationalId(dynamic fieldValue) {
  if (fieldValue is List && fieldValue.isNotEmpty) {
    return fieldValue[0] as int;
  } else if (fieldValue is int) {
    return fieldValue;
  }
  return null;
}
