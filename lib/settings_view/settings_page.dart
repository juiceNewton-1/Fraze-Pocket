import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fraze_pocket/service/mixins/smith_mixin.dart';
import 'package:fraze_pocket/styles/app_theme.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SmithMixin {
  @override
  Widget build(BuildContext context) {
    final version = AppInfo.of(context).package.version;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surface,
                      border: Border.all(
                        color: const Color.fromRGBO(45, 45, 51, 1),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 150,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/Rectangle 525.png'),
                      fit: BoxFit.contain)),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Vote for our app",
              style: AppTheme.bodyLarge
                  .copyWith(color: const Color.fromARGB(78, 252, 248, 239)),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TO MAKE US\nBETTER',
                  style: AppTheme.displayLarge
                      .copyWith(color: AppTheme.onBackground),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 1,
                  onPressed: InAppReview.instance.requestReview,
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surface,
                      border: Border.all(
                        color: const Color.fromRGBO(45, 45, 51, 1),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: AppTheme.onSurface,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 1,
              onPressed: () => launchUrlString(termsLink),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Terms of use',
                    style: AppTheme.bodyMedium
                        .copyWith(color: AppTheme.onBackground),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 92, 92, 92),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              color: Color.fromARGB(255, 63, 63, 63),
              height: 1,
            ),
            const SizedBox(
              height: 16,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 1,
              onPressed: () => launchUrlString(privacyLink),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Privacy Policy',
                    style: AppTheme.bodyMedium
                        .copyWith(color: AppTheme.onBackground),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 92, 92, 92),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              color: Color.fromARGB(255, 63, 63, 63),
              height: 1,
            ),
            const SizedBox(
              height: 16,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 1,
              onPressed: () => FlutterEmailSender.send(
                Email(
                    recipients: ['pirogovdima767@icloud.com'],
                    subject: 'Support',
                    body: 'Put your message here...'),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Support',
                    style: AppTheme.bodyMedium
                        .copyWith(color: AppTheme.onBackground),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 92, 92, 92),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              color: Color.fromARGB(255, 63, 63, 63),
              height: 1,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Version',
                  style: AppTheme.bodyMedium
                      .copyWith(color: AppTheme.onBackground),
                ),
                Text(
                  '${version.major}.${version.minor}.${version.patch}',
                  style: AppTheme.bodyMedium
                      .copyWith(color: AppTheme.onBackground),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              color: Color.fromARGB(255, 63, 63, 63),
              height: 1,
            )
          ],
        ),
      )),
    );
  }
}
