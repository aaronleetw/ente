import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photos/core/configuration.dart';
import 'package:photos/core/event_bus.dart';
import 'package:photos/events/subscription_purchased_event.dart';
import 'package:photos/services/billing_service.dart';
import 'package:photos/ui/email_entry_page.dart';
import 'package:photos/ui/password_entry_page.dart';
import 'package:photos/ui/password_reentry_page.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:photos/ui/subscription_page.dart';

class SignInHeader extends StatefulWidget {
  const SignInHeader({Key key}) : super(key: key);

  @override
  _SignInHeaderState createState() => _SignInHeaderState();
}

class _SignInHeaderState extends State<SignInHeader> {
  StreamSubscription _userAuthEventSubscription;

  @override
  void initState() {
    _userAuthEventSubscription =
        Bus.instance.on<SubscriptionPurchasedEvent>().listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _userAuthEventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hasConfiguredAccount = Configuration.instance.hasConfiguredAccount();
    var hasSubscription = BillingService.instance.getSubscription() != null;
    if (hasConfiguredAccount && hasSubscription) {
      return Container();
    } else {
      return _getBody(context);
    }
  }

  SingleChildScrollView _getBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "with ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: "ente",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(2),
            ),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "your ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: "memories",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: " are",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(8),
            ),
            ExpansionCard(
              title: Text('protected'),
              margin: EdgeInsets.all(0),
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      'only visible to you as they are encrypted by your master key',
                    ),
                  ),
                ),
              ],
            ),
            ExpansionCard(
              title: Text('preserved'),
              margin: EdgeInsets.all(0),
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      'stored in multiple locations including an underground fallout shelter',
                    ),
                  ),
                ),
              ],
            ),
            ExpansionCard(
              title: Text('accessible'),
              margin: EdgeInsets.all(0),
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      'available on all your devices',
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
            ),
            Container(
              width: double.infinity,
              height: 64,
              padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
              child: RaisedButton(
                child: Text(
                  "subscribe",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  var page;
                  if (Configuration.instance.getToken() == null) {
                    page = EmailEntryPage();
                  } else {
                    // No key
                    if (Configuration.instance.getKeyAttributes() == null) {
                      // Never had a key
                      page = PasswordEntryPage();
                    } else if (Configuration.instance.getKey() == null) {
                      // Yet to decrypt the key
                      page = PasswordReentryPage();
                    } else {
                      // All is well, user just has not subscribed
                      page = SubscriptionPage();
                    }
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return page;
                      },
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Divider(
              height: 2,
            ),
          ],
        ),
      ),
    );
  }
}
