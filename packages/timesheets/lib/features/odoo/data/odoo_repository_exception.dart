/// {@template odoo_repository_exception}
/// Thrown if during the data fetching process a failure occurs.
/// {@endtemplate}
class OdooRepositoryException implements Exception {
  /// {@macro odoo_repository_exception}
  const OdooRepositoryException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory OdooRepositoryException.fromMessage(String code) {
    if (code.contains('Failed host lookup')) {
      return const OdooRepositoryException('Invalid server url');
    } else if (code.contains('No host specified in URI') ||
        code.contains('Invalid empty scheme')) {
      return const OdooRepositoryException(
          'Please Mention host properly (Eg: http://,https://)');
    }

    return const OdooRepositoryException();
  }

  factory OdooRepositoryException.fromCode(String code) {
    if (code == 'invalid_cred') {
      return const OdooRepositoryException('Invalid Email/Password');
    }

    return const OdooRepositoryException();
  }

  /// The associated error message.
  final String message;
}

class RecondNotFoundError extends OdooRepositoryException {
  final String? model;
  final String? recordId;
  const RecondNotFoundError({
    this.model,
    this.recordId,
  }) : super('Record not found');
  static String? extractModel(String input) {
    final modelRegex = RegExp(r'(\w+\.\w+)');
    final modelMatch = modelRegex.firstMatch(input);
    if (modelMatch != null) {
      return modelMatch.group(1);
    } else {
      return null;
    }
  }

  static String? extractId(String input) {
    final idRegex = RegExp(r'\((\d+),');
    final idMatch = idRegex.firstMatch(input);
    if (idMatch != null) {
      return idMatch.group(1)!;
    } else {
      return null;
    }
  }
}
