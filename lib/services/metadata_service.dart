import 'package:http/http.dart' as http;

class MetadataService {

  static Future<String?> fetchImage(String url) async {

    try {

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {

        final html = response.body;

        final ogIndex = html.indexOf('property="og:image"');

        if (ogIndex != -1) {

          final start = html.indexOf('content="', ogIndex) + 9;
          final end = html.indexOf('"', start);

          return html.substring(start, end);

        }

      }

    } catch (e) {}

    return null;

  }

}

