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
  double viewHeight = 100;
  double viewWidth = 100;
  double bottomPosition = 10;
  double rightPosition = 0;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removeViewInsets(
      removeBottom: true,
      context: context,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: false,
        removeBottom: true,
        removeLeft: true,
        removeRight: true,
        child: Stack(
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
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'Sample Image',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          FlutterLogo(
                            size: 150,
                            style: FlutterLogoStyle.stacked,
                          ),
                        ],
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: Colors.deepPurple[100 * (index % 9)],
                            child: Center(
                              child: Text(
                                'Item $index',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: Colors.deepPurple[100 * (index % 9)],
                            child: Center(
                              child: Text(
                                'Item $index',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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
                        colors: [Colors.red, Colors.black],
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
                    setState(() {
                      viewHeight = MediaQuery.of(context).size.height;
                      viewWidth = MediaQuery.of(context).size.width;
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
        ),
      ),
    );
  }
}
