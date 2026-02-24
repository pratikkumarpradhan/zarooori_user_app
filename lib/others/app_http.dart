// import 'dart:io';

// import 'package:http/http.dart' as http;
// import 'package:http/io_client.dart';

// const String _apiHost = 'admin.aswack.com';

// late final http.Client _client = _createClient();

// HttpClient _createHttpClient() {
//   return HttpClient()
//     ..connectionTimeout = const Duration(seconds: 30)
//     ..idleTimeout = const Duration(seconds: 25)
//     ..badCertificateCallback = (X509Certificate cert, String host, int port) {
//       // Workaround: backend currently serves inconsistent/invalid TLS certs.
//       // Keep this strictly scoped to our API host.
//       return host == _apiHost;
//     };
// }

// http.Client _createClient() {
//   final ioClient = _createHttpClient();
//   final inner = IOClient(ioClient);
//   return _DefaultHeadersClient(
//     inner: inner,
//     defaultHeaders: {
//       'User-Agent': 'Zarooori/1.0 (Android; Mobile)',
//       'Accept': 'application/json, text/plain, */*',
//       'Connection': 'keep-alive',
//     },
//   );
// }

// /// Wraps a [http.Client] and adds default headers to every request so the
// /// server does not close the connection (some backends require User-Agent).
// class _DefaultHeadersClient extends http.BaseClient {
//   _DefaultHeadersClient({
//     required http.Client inner,
//     required Map<String, String> defaultHeaders,
//   })  : _inner = inner,
//         _defaultHeaders = defaultHeaders;

//   final http.Client _inner;
//   final Map<String, String> _defaultHeaders;

//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) {
//     for (final e in _defaultHeaders.entries) {
//       request.headers.putIfAbsent(e.key, () => e.value);
//     }
//     return _inner.send(request);
//   }
// }

// /// Shared HTTP client for all API calls. Uses a custom [HttpClient] that
// /// accepts the API server certificate and sends default headers to avoid
// /// "ClientConnection closed before full header was received".
// http.Client get appHttpClient => _client;
