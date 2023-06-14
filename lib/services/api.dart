import 'dart:convert';
import 'package:http/http.dart' as http;

String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiIyN2NmMzBmOC01OThlLTQwMTMtYjFjZC02NWExZTI0NWE4MjQiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY4MDE1ODY2NCwiZXhwIjoxNzExNjk0NjY0fQ.JR6aDPwKc8qCWK8tTiv3f-LMLNSaBFVxAUZkbUMlUXU";

Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': token},
  );

  return json.decode(httpResponse.body)['roomId'];
}