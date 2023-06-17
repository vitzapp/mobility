typedef QueryParameters = Map<String, dynamic>;

String _makeQuery(QueryParameters params) {
  var result = StringBuffer();
  var separator = '';

  void writeParameter(String key, String? value) {
    result.write(separator);
    separator = '&';
    result.write(Uri.encodeQueryComponent(key));
    if (value != null && value.isNotEmpty) {
      result.write('=');
      result.write(Uri.encodeQueryComponent(value));
    }
  }

  params.forEach((key, value) {
    if (value == null || value is String) {
      writeParameter(key, value);
    }
  });

  return result.toString();
}

Uri buildRequestUri(String base, String endpoint, QueryParameters params) {
  return Uri.parse('$base/$endpoint?${_makeQuery(params)}');
}
