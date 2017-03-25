//
//  ZCWebController.h
//  ZCWebController
//
//  Created by Jason on 25/03/2017.
//  Copyright © 2017 Jason Digital Studio. All rights reserved.
//


#import <WebKit/WebKit.h>

@interface ZCWebController : UIViewController<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
// 加载进度条颜色
@property (nonatomic, strong) UIColor *progressBarColor;

- (void)loadUrl:(NSString *)url;

- (NSString *)getCommonStatWithUrl:(NSString *)url;

- (void)backBtnClick:(UIButton *)sender;

/*! @override是否允许跳转 */
- (WKNavigationActionPolicy)webView:(WKWebView *)webView
          policyForNavigationAction:(WKNavigationAction *)navigationAction;
@end
