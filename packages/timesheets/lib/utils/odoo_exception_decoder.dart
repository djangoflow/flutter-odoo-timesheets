String? extractMessageFromData(String exceptionMessage) {
  // Regular expression to match the 'data' section and extract the 'message' inside 'data'
  RegExp dataMessagePattern =
      RegExp(r'data: \{.*?message: (.*?)(?=, arguments:)', dotAll: true);

  // Try to match the pattern in the exception message
  var match = dataMessagePattern.firstMatch(exceptionMessage);

  if (match != null) {
    // Extract the message and trim any excess characters
    String? message = match.group(1)?.trim();
    // Remove any leading/trailing quotes if present

    return message;
  }

  return null; // Return null if no message is found
}
