//
//  ViewController.m
//  ZCWebController
//
//  Created by Jason on 25/03/2017.
//  Copyright © 2017 Jason Digital Studio. All rights reserved.
//

#import "ViewController.h"
#import "ZCWebController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZCWebController *vc = [[ZCWebController alloc] initWithUrl:@"https://www.baidu.com"];
    [self.view addSubview:vc.view];
    vc.progressBarColor = [UIColor redColor];
    vc.view.frame = self.view.bounds;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
