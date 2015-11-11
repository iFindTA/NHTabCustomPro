//
//  ViewController.m
//  NHTabCustomPro
//
//  Created by hu jiaju on 15/11/11.
//  Copyright © 2015年 hu jiaju. All rights reserved.
//

#import "ViewController.h"
#import "NHTabBarItem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Tab Bar Pro";
    
    
    CGRect infoRect = CGRectMake(20, 100, 50, 50);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = infoRect;
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushEvents) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    infoRect.origin.x += 60;
    NHTabBarItem *barItem = [[NHTabBarItem alloc] initWithFrame:infoRect];
    barItem.fontName = @"iconfont";
    barItem.iconInfo = @"\U000f0005";
    barItem.titleInfo = @"\U00003432";
    barItem.isSelect = true;
    [self.view addSubview:barItem];
}

- (void)pushEvents {
    ViewController *vcr = [[ViewController alloc] init];
    vcr.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vcr animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
