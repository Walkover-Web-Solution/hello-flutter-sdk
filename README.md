# Flutter Chat Widget by MSG91 # HelloSDK

<img src="https://user-images.githubusercontent.com/60983778/207020610-9eb32587-7878-4604-bdaf-88ec87f634f8.jpg" height="400">

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
class _MyHomePageState extends State<MyHomePage> {
  //Initialize the chat widget height,width and position.
  double viewHeight = 80;
  double viewWidth = 80;
  double bottomPosition = 10;
  double rightPosition = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: bottomPosition,
          right: rightPosition,
          child: SizedBox(
            height: viewHeight,
            width: viewWidth,
            child: ChatWidget(
              //You can create your custom button  
              button: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.red,
                      Colors.black,
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Chat",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              widgetToken: "Your Hello Widget Token",
              uniqueId: "AA_94bb_0jd", //(Optional)
              name: "John Doe", //(Optional)
              widgetColor: const Color.fromARGB(255, 209, 58, 12),
              onLaunchWidget: () {
                // set the view height/width to full height/width of the screen
                setState(() {
                  viewHeight = MediaQuery.of(context).size.height;
                  viewWidth = MediaQuery.of(context).size.width;
                  bottomPosition = 0;
                  rightPosition = 0;
                });
              },
              onHideWidget: () {
                // set the button height/width on the screen
                setState(() {
                  viewHeight = 80;
                  viewWidth = 80;
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
}
```

## Properties

Below are the properties available for customizing the Widget.

| Prop                         | Type              | Description  |
| ---------------------------- | ----------------- | ------- |
| widgetToken                  | String (Required) | Get Hello widget token from Widget settings > Integration |
| widgetColor                  | Color (Required) | Sets StatusBar color and widget's background color |
| name                  | String | Predefine the name of the client|
| number                  | String | Predefine the number of the client|
| mail                  | String | Predefine the mail of the client|
| country                  | String | Predefine the country of the client|
| city                  | String | Predefine the city of the client|
| region                  | String | Predefine the region of the client|
| uniqueId               | String            | Prefered unique Id to register the user          |
| showWidgetForm                    | boolean           |  Override default widget show client form settings|
| showSendButton                    | boolean           |  Override default show send button widget settings|
| button                    | Widget           |  Create your own custom button widget|

