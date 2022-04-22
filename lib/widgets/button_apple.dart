import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppleSignInButton extends StatelessWidget {
  final ValueSetter<AuthorizationCredentialAppleID> onSignIn;

  const AppleSignInButton({Key? key,required this.onSignIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: NeuButton(

        onTap: () async {
          final credential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );
          onSignIn(credential);
        },
        child: Wrap(
          crossAxisAlignment:
          WrapCrossAlignment.center,
          children: [
            SizedBox(
                height: 46,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Image.asset(
                      'images/apple.png'),
                )),
            const SizedBox(
              width: 3.0,
            ),
            Text(
              AppLocalizations.of(context)!
                  .sign_in_apple,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(
                  fontSize: 14.0,
                  color: Colors.white),
            ),
          ],
        )
      ),
    );
  }
}