import 'package:flutter/material.dart';
import 'package:hello_flutter_sdk/hello_flutter_sdk.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hello SDK Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /* -------------------------------------------------------------------------
  These varible [viewHeight, viewWidth, bottomPosition, rightPosition] are 
  important to handle the screen button and Chat Widget View
  You can either handle this using set state or any other State Management you 
  you use.

  NOTE: I have used bottomPosition and rightPosition in variable also in 
  Postion Widget you can use [Top, Bottom, Left, Right] any but if you have 
  placed you button anyother place of the screen use the values accordingly
  
  */
  double viewHeight = 80;
  double viewWidth = 80;
  double bottomPosition = 10;
  double rightPosition = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: const Text('Flutter Hello SDK Example'),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sample Image',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const FlutterLogo(
                  size: 150,
                  style: FlutterLogoStyle.stacked,
                ),
                const Text(
                  'Sample GridView',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.deepPurple[100 * (index % 9)],
                        child: Center(
                          child: Text('Item $index'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sample GridView',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.deepPurple[100 * (index % 9)],
                        child: Center(
                          child: Text('Item $index'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: bottomPosition,
          right: rightPosition,
          child: SizedBox(
            height: viewHeight,
            width: viewWidth,
            child: ChatWidget(
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
              widgetToken: "ec5d6",
              uniqueId: "AA_94bb_0jd",
              name: "John Doe",
              mail: "johndoe@example.com",
              number: "+1234567890",
              widgetColor: const Color.fromARGB(255, 209, 58, 12),
              onLaunchWidget: () {
                // set the view hight/width to full hight/width of the screen
                setState(() {
                  viewHeight = MediaQuery.of(context).size.height;
                  viewWidth = MediaQuery.of(context).size.width;
                  bottomPosition = 0;
                  rightPosition = 0;
                });
              },
              onHideWidget: () {
                // set the button hight/width on the screen
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
