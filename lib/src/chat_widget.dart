import 'dart:convert';
import 'dart:developer';

// import 'package:cobrowseio_flutter/cobrowseio_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatWidget extends StatefulWidget {
  final String widgetToken;
  final Color widgetColor;
  final String uniqueId;
  bool hideLauncher;
  bool showWidgetForm;
  bool showCloseButton;
  bool launchWidget;
  bool showSendButton;
  final String? name;
  final String? number;
  final String? mail;
  final String? country;
  final String? city;
  final String? region;
  final VoidCallback onLaunchWidget;
  final VoidCallback onHideWidget;
  final Widget button;

  ChatWidget(
      {super.key,
      required this.widgetToken,
      required this.widgetColor,
      required this.uniqueId,
      this.hideLauncher = false,
      this.showWidgetForm = false,
      this.showCloseButton = true,
      this.launchWidget = false,
      this.showSendButton = true,
      this.name,
      this.number,
      this.mail,
      this.country,
      this.city,
      this.region,
      required this.onLaunchWidget,
      required this.onHideWidget,
      required this.button});

  @override
  ChatWidgetState createState() => ChatWidgetState();
}

class ChatWidgetState extends State<ChatWidget> with WidgetsBindingObserver {
  InAppWebViewController? _webViewController;
  bool _isWidgetLoaded = false;
  bool initialLoading = false;
  bool showView = false;

  Future<void> changeStatusBarColor() async {
    await FlutterStatusbarcolor.setStatusBarColor(widget.widgetColor);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _webViewController?.dispose();
    super.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        changeStatusBarColor();
        break;
      case AppLifecycleState.inactive:
        changeStatusBarColor();
        break;
      case AppLifecycleState.paused:
        changeStatusBarColor();
        break;
      case AppLifecycleState.detached:
        changeStatusBarColor();
        break;
      case AppLifecycleState.hidden:
        changeStatusBarColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (showView) {
          widget.onHideWidget();
          setState(() {
            showView = false;
          });
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Visibility(
                maintainState: true,
                visible: showView,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(
                        "https://control.msg91.com/app/assets/dummy-page/index.html"),
                  ),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true,
                      useOnLoadResource: true,
                      useShouldOverrideUrlLoading: true,
                    ),
                  ),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                    if (_isWidgetLoaded) {
                      _openChatWidget();
                    } else {
                      _loadChatWidget();
                    }
                    _webViewController?.addJavaScriptHandler(
                      handlerName: 'widgetEventHandler',
                      callback: (args) {
                        _handleWidgetEvents(args[0]);
                      },
                    );
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    final url = navigationAction.request.url.toString();
                    if (await canLaunch(url)) {
                      await launch(url,
                          forceSafariVC: false, forceWebView: false);
                      return NavigationActionPolicy.CANCEL;
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    if (_isWidgetLoaded) {
                      _openChatWidget();
                    } else {
                      _loadChatWidget();
                    }
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    log("Console message: ${consoleMessage.message}");
                  },
                ),
              ),
              if (initialLoading)
                Visibility(
                  visible: !showView,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isWidgetLoaded = true;
                        showView = !showView;
                      });
                      widget.onLaunchWidget();
                      if (showView) {
                        await changeStatusBarColor();
                      } else {
                        await FlutterStatusbarcolor.setStatusBarColor(
                            Colors.transparent);
                      }
                    },
                    child: widget.button ?? Container(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadChatWidget() {
    String customThemeHex =
        '#${widget.widgetColor.value.toRadixString(16).substring(2).toUpperCase()}';

    String injectedScript = '''
      (function () {
        console.log("Injecting chat widget script");

        var helloConfig = {
          widgetToken: '${widget.widgetToken}',
          hide_launcher: ${widget.hideLauncher},
          show_widget_form: ${widget.showWidgetForm},
          show_close_button: ${widget.showCloseButton},
          launch_widget: ${widget.launchWidget},
          show_send_button: ${widget.showSendButton},
          unique_id: '${widget.uniqueId}',
          name: '${widget.name ?? ''}',
          number: '${widget.number ?? ''}',
          mail: '${widget.mail ?? ''}',
          country: '${widget.country ?? ''}',
          city: '${widget.city ?? ''}',
          region: '${widget.region ?? ''}',
          isMobileSDK: true,
          preLoaded: false,
          sdkConfig: {
            callBackWithoutClose: true,
            borderRadiusDisable: true,
            customTheme: '$customThemeHex',
          },
          widgetClose: (data) => {
            window.flutter_inappwebview.callHandler('widgetEventHandler', JSON.stringify({widgetClose: true}));
          },
          widgetClientData: (data) => {
            window.flutter_inappwebview.callHandler('widgetEventHandler', JSON.stringify(data));
          },
        };

        function loadOrOpenChatWidget() {
          if (typeof window.chatWidget !== 'undefined') {
            console.log("Chat widget script already injected, opening chat widget");
            window.chatWidget.open();
            window.flutter_inappwebview.callHandler('widgetLoaded');
          } else {
            var JScript = document.createElement('script');
            JScript.id = 'chat-widget-script';
            JScript.setAttribute('src','https://control.msg91.com/app/assets/widget/chat-widget.js');
            document.head.appendChild(JScript);

            JScript.onload = function() {
              console.log("Chat widget script loaded");

              setTimeout(function() {
                if (typeof initChatWidget !== 'undefined') {
                  console.log("Initializing chat widget");
                  initChatWidget(helloConfig, 0);
                  setTimeout(function() {
                    if (typeof window.chatWidget !== 'undefined') {
                      window.chatWidget.open();
                      console.log("Chat widget opened");
                      window.flutter_inappwebview.callHandler('widgetLoaded');
                    } else {
                      console.error('window.chatWidget is not defined.');
                    }
                  }, 1000);
                } else {
                  console.error('initChatWidget is not defined.');
                }
              }, 500);
            };

            var metaTag = document.createElement('meta');
            metaTag.setAttribute('name','viewport');
            metaTag.setAttribute('content','width=device-width, initial-scale=1.0, maximum-scale=1.0');
            document.head.appendChild(metaTag);
          }
        }

        loadOrOpenChatWidget();
      })();
    ''';

    _webViewController?.evaluateJavascript(source: injectedScript);
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        initialLoading = true;
      });
    });
  }

  void _openChatWidget() {
    String openChatScript = '''
      if (typeof window.chatWidget !== 'undefined') {
        window.chatWidget.open();
      }
    ''';

    _webViewController?.evaluateJavascript(source: openChatScript);
  }

  Future<void> _handleWidgetEvents(String eventData) async {
    final data = jsonDecode(eventData);
    log("----data: $data");
    print("----data------: $data");
    if (data['widgetClose'] == true) {
      setState(() {
        showView = false;
      });
      widget.onHideWidget();
      if (showView) {
        await changeStatusBarColor();
      } else {
        await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
      }
    } else if (data['uuid'] != null) {
      final uuid = data['uuid'];
      _registerForCobrowse(uuid);
    } else if (data['downloadAttachment'] == true) {
      final attachmentUrl = data['attachment_url'];
      _openUrlExternally(attachmentUrl);
    }
  }

  void _registerForCobrowse(String uuid) async {
    log("Registering for co-browsing with UUID: $uuid");
    // await CobrowseIO.start(" FZBGaF9-Od0GEQ", {'device_id': uuid});

    // if (!await CobrowseIO.accessibilityServiceIsRunning()) {
    //   CobrowseIO.accessibilityServiceOpenSettings();
    // }

    // CobrowseIO.accessibilityServiceShowSetup();
  }

  void _openUrlExternally(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      log("Could not launch URL: $url");
    }
  }
}
