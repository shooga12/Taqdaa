import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';
import 'dart:convert' as convert;

class PaypalServices {
  String domain = 'https://api.sandbox.paypal.com';
  String clientId =
      'AS3ehaFMzfpGoyReXjQncnaVHTpC9J78HEuVIXtxY0tpi41__B7wEgja1YEK2Cujdy4Mm6cYbMDjtDYR';
  String secret =
      'EDe-LoPiL5OkNhf6G-4S7fHXkPVOHXv8phIMqdRujpPx4y1UMwk-FqxTaOZxVho0w04yiPB_aW8MD8UC';

  Future<String> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body['access_token'];
      }
      return '0';
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post(Uri.parse('$domain/v1/payments/payment'),
          headers: {
            "content-type": "application.json",
            "Authorization": "Bearer" + accessToken
          });
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length() > 0) {
          List links = body["links"];
          String executeUrl = '';
          String approvalUrl = '';

          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }

          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item != null) {
            executeUrl = item1["href"];
          }

          return {'executeUrl': executeUrl, 'approvalUrl': approvalUrl};
        }
        throw Exception(0);
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(url,
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            "Authorization": "Bearer" + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return '0';
    } catch (e) {
      rethrow;
    }
  }
}
