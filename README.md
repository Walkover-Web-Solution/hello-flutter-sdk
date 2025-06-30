# Flutter Chat Widget by MSG91 # HelloSDK
<br/>
<img src="https://raw.githubusercontent.com/Walkover-Web-Solution/hello-flutter-sdk/main/resources/banner.jpg" width="100%" align="left" />
<br/>
 
## Getting started

Login or create account at MSG91 to use Hello SDK service.

After login at MSG91 follow below steps to get your hello chat widget configuration.
* From navigation drawer expand Manage > Inboxes > Select Inbox as Chat > Edit Widget.
* Configure your widget.

## Installing

``` 
flutter pub add hello_flutter_sdk
```

## Usage

```
import 'package:flutter/material.dart';
import 'package:hello_flutter_sdk/hello_flutter_sdk.dart';
```

```
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HelloExampleScreen(),
    );
  }
}

class HelloExampleScreen extends StatefulWidget {
  const HelloExampleScreen({super.key});

  @override
  State<HelloExampleScreen> createState() => _HelloExampleScreenState();
}

class _HelloExampleScreenState extends State<HelloExampleScreen> {
  double viewHeight = 100, viewWidth = 100;
  double bottomPosition = 10, rightPosition = 0;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Hello Chat SDK")),
          body: const Center(child: Text("Welcome to Hello SDK Example")),
        ),
        Positioned(
          bottom: bottomPosition,
          right: rightPosition,
          child: SizedBox(
            height: viewHeight,
            width: viewWidth,
            child: ChatWidget(
              button: _chatButton(),
              widgetToken: "YOUR_WIDGET_TOKEN",
              uniqueId: "UNIQUE_USER_ID",
              name: "User Name"",
              mail: "email@example.com",
              number: "+1234567890",
              widgetColor: Colors.deepOrange,
              onLaunchWidget: () {
                setState(() {
                  viewHeight = media.size.height;
                  viewWidth = media.size.width;
                  bottomPosition = 0;
                  rightPosition = 0;
                });
              },
              onHideWidget: () {
                setState(() {
                  viewHeight = 100;
                  viewWidth = 100;
                  bottomPosition = 10;
                  rightPosition = 0;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _chatButton() {
    return Container(
      height: 80,
      width: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.red, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: Text(
          "Chat",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
```

## Properties

Below are the properties available for customizing the Widget.

| Prop                         | Type              | Description  |
| ---------------------------- | ----------------- | ------- |
| widgetToken                  | String (Required) | Get Hello widget token from Widget settings > Integration |
| widgetColor                  | Color (Required) | Sets Widget's background color |
| uniqueId               | String (Required)           | Prefered unique Id to register the user          |
| userJwtToken               | String           | Identity Verification must be enabled to use this prop        |
| name                  | String | Predefine the name of the client|
| number                  | String | Predefine the number of the client|
| mail                  | String | Predefine the mail of the client|
| country                  | String | Predefine the country of the client|
| city                  | String | Predefine the city of the client|
| region                  | String | Predefine the region of the client|
| showWidgetForm                    | boolean           |  Override default widget show client form settings|
| showSendButton                    | boolean           |  Override default show send button widget settings|
| button                    | Widget           |  Create your own custom button widget|

