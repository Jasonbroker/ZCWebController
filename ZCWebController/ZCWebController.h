//
//  ZCWebController.h
//  ZCWebController
//
//  Created by Jason on 25/03/2017.
//  Copyright © 2017 Jason Digital Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ZCWebController : UIViewController<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong, readonly) WKWebView *webView;
// 加载进度条颜色
@property (nonatomic, strong) UIColor *progressBarColor;

- (instancetype)initWithUrl:(NSString *)url;

- (void)loadUrl:(NSString *)url;

/*! @override是否允许跳转 */
- (WKNavigationActionPolicy)webView:(WKWebView *)webView
          policyForNavigationAction:(WKNavigationAction *)navigationAction;
@end
