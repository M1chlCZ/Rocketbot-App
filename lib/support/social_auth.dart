import 'package:oauth2_client/oauth2_client.dart';

class DiscordAuthClient extends OAuth2Client {
  DiscordAuthClient(): super(
      authorizeUrl: 'https://discord.com/api/oauth2/authorize', //Your service's authorization url
      tokenUrl: 'https://discord.com/api/oauth2/token', //Your service access token url
      redirectUri: 'app.rocketbot.pro://oauth2redirect',
      customUriScheme: 'app.rocketbot.pro',
    credentialsLocation: CredentialsLocation.BODY
  );
}