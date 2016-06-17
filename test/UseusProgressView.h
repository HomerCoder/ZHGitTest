//
//  UseusProgressView.h
//  CustomHUD
//
//  Created by Leo on 15/11/16.
//  Copyright © 2015年 Leo‘s. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UseusInstance.h"
/**
 *  实例化方法 1
 *  UseusProgressView *hud = [UseusProgressView sharedProgressView];
 *  hud.labelText = title;
 *  hud.mode = MBProgressHUDModeText;
 *  [hud show:YES];
 *  [hud hide:YES afterDelay:1.f];
 *
 *  实例化方法 2
 *  直接使用 eg: [self showProgressViewTitle:@"网络不给力...\n 请检查网络并重试！" mode:ProgressViewModeText afterDelay:1.2f];
 */
typedef NS_ENUM(NSInteger, UseusProgressViewMode) {
    UseusProgressViewModeText,
    UseusProgressViewModeCustomView
};

@interface UseusProgressView : UIView
sharedInstance_h(ProgressView)

@property (nonatomic, assign) UseusProgressViewMode mode;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) NSString *labelText;

/**
 *  显示
 *
 *  @param animated 是否需要动画
 */

- (void)show:(BOOL)animated;

/**
 *  隐藏
 *
 *  @param animated 是否需要动画
 */- (void)hide:(BOOL)animated;

/**
 *  延时隐藏
 *
 *  @param animated 是否需要动画
 *  @param delay    时间
 */
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end
