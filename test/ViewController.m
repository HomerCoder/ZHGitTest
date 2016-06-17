//
//  ViewController.m
//  test
//
//  Created by zhanghong on 16/6/16.
//  Copyright © 2016年 ysh. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "UseusProgressView.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, ProgressViewMode) {
    ProgressViewModeText,
    ProgressViewModeCustomView
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createBtn];
}

- (void)createBtn {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick : (UIButton *)btn {
    [self showProgressViewTitle:@"替换终端失败，请重试！" mode:ProgressViewModeText afterDelay:1.f];
}

- (void)showProgressViewTitle:(NSString *)title mode:(ProgressViewMode)mode afterDelay:(NSTimeInterval)delay {
    if (mode == ProgressViewModeCustomView) {
        AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[dele window] animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
        hud.labelText = title;
        [hud show:YES];
        [hud hide:YES afterDelay:delay];
    } else {
        UseusProgressView *hud = [UseusProgressView sharedProgressView];
        hud.labelText = title;
        hud.mode = MBProgressHUDModeText;
        [hud show:YES];
        [hud hide:YES afterDelay:delay];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
