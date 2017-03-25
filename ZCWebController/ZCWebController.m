//
//  ZCWebController.m
//  ZCWebController
//
//  Created by Jason on 25/03/2017.
//  Copyright © 2017 Jason Digital Studio. All rights reserved.
//
#import <NJKWebViewProgress/NJKWebViewProgressView.h>

NSString *WebControllerQueryNotUsingCommonstate = @"notUsingCommon";

@interface WKWebViewConfiguration (defaultConfigration)

+ (instancetype)defaultConfigration;

@end

@interface SNWebViewController ()

@end

@implementation SNWebViewController {
    
    NSString *_url;
    NSString *_initialTitle;
    BOOL _notUsingCommon;
    
    // 界面上方的进度条展示
    NJKWebViewProgressView *_progressView;
    
    NSURL *_currentMainUrl;
}

- (id)initWithQuery:(NSDictionary *)query {
    self = [super initWithQuery: query];
    if (self) {
        
        _initialTitle = query[@"title"];
        self.title = _initialTitle;
        _url = query[@"url"];
        _notUsingCommon = [query[WebControllerQueryNotUsingCommonstate] boolValue];
        
    }
    return self;
}

- (BOOL)needScrollView {
    return NO;
}

- (void)dealloc {
    // 取消kvo
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[WKWebView alloc] initWithFrame: self.view.bounds
                                  configuration:[WKWebViewConfiguration defaultConfigration]];
    _webView.opaque = YES;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview: _webView];
    
    // 进度条
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame: CGRectMake(0, self.topOffset, self.view.width, 2)];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressView.progressBarView.backgroundColor = RGBCOLOR_HEX(0xff8200);
    [self.view addSubview: _progressView];
    
    // 添加进度监听
    [_webView addObserver:self
               forKeyPath:@"estimatedProgress"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    
    if (_notUsingCommon) {
        [self loadUrl: _url];
    } else {
        [self loadUrl: [self getCommonStatWithUrl: _url]];
    }
}

- (NSString*)getCommonStatWithUrl:(NSString*)url {
    NIDASSERT(NO && @"子类需要重写这个方法， 返回带参数的url");
    //    return [url urlPathWithCommonStat];
    return url;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)backToLastController:(id)sender {
    
    if ([_webView canGoBack]) {
        [_webView goBack];
        [self addCloseButton];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addCloseButton {
    //返回按钮
    //    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,90, 30)];
    //    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, 40, 30)];
    //    [backBtn setImage: [[FOResource load: @"back_right"] imageWithTintColor: RGBCOLOR_HEX(0x525252)] forState:UIControlStateNormal];
    //    [backBtn setImage: [[FOResource load: @"back_right"] imageWithTintColor: RGBCOLOR_HEX(0x323232)] forState:UIControlStateHighlighted];
    //    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [parentView addSubview:backBtn];
    //
    //    //关闭按钮
    //    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(backBtn.right-10, 0, 50, 30)];
    //    [closeButton addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    //    [closeButton setTitleColor:RGBCOLOR_HEX(0x525252) forState:UIControlStateNormal];
    //    [parentView addSubview:closeButton];
    //    UIBarButtonItem *customBarButtomItem = [[UIBarButtonItem alloc] initWithCustomView:parentView];
    //    self.navigationItem.leftBarButtonItem = customBarButtomItem;
}

- (void)backBtnClick:(UIButton *)sender {
    
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeBtnClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadUrl:(NSString*)url {
    NIDPRINT(@"loading url is %@", url);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - UIDelegate (on calling time sequence)
//  Decides whether to allow or cancel a navigation.
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NIDPRINT(@"");
    decisionHandler([self webView:webView policyForNavigationAction:navigationAction]);
}

// override this method to change the
- (WKNavigationActionPolicy)webView:(WKWebView *)webView policyForNavigationAction:(WKNavigationAction *)navigationAction {
    return WKNavigationActionPolicyAllow;
}

//  Start ProvisionNavigation loading web content. Do Things like spinning an activity indicator On the status bar.
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NIDPRINT(@"");
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//  Decides whether to allow or cancel a navigation after its response is known.
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NIDPRINT(@"");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//  Response has been allowed.
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NIDPRINT(@"");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NIDPRINT(@"");
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([_initialTitle isNonEmpty] && ![_webView canGoBack]) {
        self.title = _initialTitle;
    }else {
        // get title from html's document.title
        self.title = _webView.title;
    }
}

/* Error handling */
// Called after an error occured, while the web view is loading content. Commonly network error, time out error .etc
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NIDPRINT(@"%@", error);
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSURL *errorUrl = error.userInfo[NSURLErrorFailingURLErrorKey];
    if ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102) {
        
        // when shouldload: method return NO, will cause webview load this error
    }else {
        if ([errorUrl isEqual: _currentMainUrl]) {
#ifdef IN_SPEAKOUT
            //        [MBProgressHUD showErrorWithStatus: SNDescriptionForError(error)];
            NSString *errorString = SNDescriptionForError(error);
            if (![errorString isNonEmpty]) {
                errorString = @"加载失败";
            }
            // FIXME:
            // [_webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat: @"document.write(\"%@，请返回重试\");", errorString]];
#else
#endif
        }
    }
}

// Called when an error occurs during navigation.
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NIDPRINT(@"");
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // [MBProgressHUD showErrorWithStatus: @"网络连接错误"];
    
    NSURL *errorUrl = error.userInfo[NSURLErrorFailingURLErrorKey];
    if ([errorUrl isEqual: _currentMainUrl]) {
#ifdef IN_SPEAKOUT
        // [MBProgressHUD showErrorWithStatus: SNDescriptionForError(error)];
        NSString *errorString = SNDescriptionForError(error);
        if (![errorString isNonEmpty]) {
            errorString = @"加载失败";
        }
        [self.webView evaluateJavaScript:[NSString stringWithFormat: @"document.write(\"%@，请返回重试\");", errorString] completionHandler:nil];
#else
#endif
    }
    
}

#pragma mark - WKScriptMessageHandler
// for js usage
/*
 - (void)userContentController:(WKUserContentController *)userContentController
 didReceiveScriptMessage:(WKScriptMessage *)message {
 NIDPRINT(@"%s", __func__);
 }
 */

// progress KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [_progressView setProgress:self.webView.estimatedProgress animated:YES];
    }
}

#pragma setter getter
- (void)setProgressBarColor:(UIColor *)progressBarColor {
    _progressView.progressBarView.backgroundColor = progressBarColor;
}

- (UIColor *)progressBarColor {
    return _progressView.progressBarView.backgroundColor;
}

@end

@implementation WKWebViewConfiguration(defaultConfigration)

+ (instancetype)defaultConfigration {
    // webview configuration
    /*
     replacement of _webView.scalesPageToFit = YES;
     http://stackoverflow.com/questions/26295277/wkwebview-equivalent-for-uiwebviews-scalespagetofit
     */
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[self.class alloc] init];
    wkWebConfig.userContentController = wkUController;
    wkWebConfig.dataDetectorTypes = UIDataDetectorTypeLink;
    return wkWebConfig;
}

@end
