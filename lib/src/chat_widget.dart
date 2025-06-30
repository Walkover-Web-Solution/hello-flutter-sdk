import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatWidget extends StatefulWidget {
  final String widgetToken;
  final Color widgetColor;
  final String uniqueId;
  final bool hideLauncher;
  final bool showWidgetForm;
  final bool showCloseButton;
  final bool launchWidget;
  final bool showSendButton;
  final String? name;
  final String? number;
  final String? userJwtToken;
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
      this.userJwtToken,
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
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    useOnLoadResource: true,
                    useShouldOverrideUrlLoading: true,
                    allowsBackForwardNavigationGestures: true,
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
                    if (url.contains("dummy-page") || 
                        url.contains("blacksea") || url.contains("chat-widget")) {
                      return NavigationActionPolicy.ALLOW;
                    } 
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
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
                    },
                    child: widget.button,
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
          user_jwt_token: '${widget.userJwtToken ?? ''}',
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
          
        };

        function loadOrOpenChatWidget() {
          if (typeof window.chatWidget !== 'undefined') {
            window.chatWidget.open();
            window.flutter_inappwebview.callHandler('widgetLoaded');
          } else {
            var JScript = document.createElement('script');
            JScript.id = 'chat-widget-script';
            JScript.setAttribute('src','https://blacksea.msg91.com/chat-widget.js');
            document.head.appendChild(JScript);

            JScript.onload = function() {

              setTimeout(function() {
                if (typeof initChatWidget !== 'undefined') {
                  console.log("Initializing chat widget");
                  initChatWidget(helloConfig, 0);
                  setTimeout(function() {
                    if (typeof window.chatWidget !== 'undefined') {
                      window.chatWidget.open();
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
          window.addEventListener("message", function(event) {
          try {
           let parsedData;
              try {
                parsedData = typeof event.data === "string" ? JSON.parse(event.data) : event.data;
              } catch (e) {
                parsedData = event.data;
              } 
              window.flutter_inappwebview.callHandler('widgetEventHandler', JSON.stringify(parsedData));
          } catch (e) {
            console.error("Failed to forward postMessage to Flutter", e);
          }
        });
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
    final type = data['type'];
    final inner = data['data'];

    if (type == 'close') {
      setState(() {
        showView = false;
      });
      widget.onHideWidget();
    } else if (type == 'downloadAttachment') {
      final url = inner is Map ? inner['url'] : inner;
      _openUrlExternally(url);
    } else if (type == 'openLink') {
      final url = inner is Map ? inner['url'] : inner;
      _openUrlExternally(url);
    }
    // else if (data['uuid'] != null) {
    //   _registerForCobrowse(data['uuid']);
    // }
  }

  void _registerForCobrowse(String uuid) async {
    // await CobrowseIO.start(" FZBGaF9-Od0GEQ", {'device_id': uuid}); 
    // if (!await CobrowseIO.accessibilityServiceIsRunning()) {
    //   CobrowseIO.accessibilityServiceOpenSettings();
    // }
    // CobrowseIO.accessibilityServiceShowSetup();
  }

  void _openUrlExternally(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      log("Could not launch URL: $url");
    }
  }
}
