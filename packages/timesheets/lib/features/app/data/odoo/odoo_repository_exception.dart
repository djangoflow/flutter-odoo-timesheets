/// {@template odoo_repository_exception}
/// Thrown if during the data fetching process a failure occurs.
/// {@endtemplate}
class OdooRepositoryException implements Exception {
  /// {@macro odoo_repository_exception}
  const OdooRepositoryException([
    this.message = 'An unknown exception occurred.',
  ]);

  ///TODO implement once we have a clear data on exceptions
  ///Unable to find documentation on error codes of odoo, keeping it like this for future implementation
  factory OdooRepositoryException.fromCode(String code) =>
      const OdooRepositoryException();

  /// The associated error message.
  final String message;
}
