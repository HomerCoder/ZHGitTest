//
//  UseusProgressView.m
//  CustomHUD
//
//  Created by Leo on 15/11/16.
//  Copyright © 2015年 Leo‘s. All rights reserved.
//

#import "UseusProgressView.h"
#import "UIColor+expanded.h"
#import "AppDelegate.h"

#if defined(__LP64__) && __LP64__
# define CGFLOAT_TYPE double
# define CGFLOAT_IS_DOUBLE 1
# define CGFLOAT_MIN DBL_MIN
# define CGFLOAT_MAX DBL_MAX
#else
# define CGFLOAT_TYPE float
# define CGFLOAT_IS_DOUBLE 0
# define CGFLOAT_MIN FLT_MIN
# define CGFLOAT_MAX FLT_MAX
#endif

static const CGFloat kLabelFontSize = 16.f;

@interface UseusProgressView()
@property (nonatomic, strong) UIView *amazonView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation UseusProgressView
sharedInstance_m(ProgressView)

- (UIView *)amazonView {
    if (!_amazonView) {
        _amazonView = [[UIView alloc] init];
        _amazonView.backgroundColor = [UIColor colorWithHexString:@"636363"];
        _amazonView.layer.cornerRadius = 3;
        _amazonView.alpha = 0.9;
    }
    return _amazonView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:kLabelFontSize];
        _label.textColor = [UIColor whiteColor];
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        [self updateIndicators];
        [self registerForKVO];
    }
    
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
//    [[PublicFunction getAppWindow] addSubview:self];
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[dele window] addSubview:self];
    [self addSubview:self.amazonView];
    [self.amazonView addSubview:self.label];
}

- (void)updateIndicators {
    if (self.mode == UseusProgressViewModeText) {
        self.label.text = self.labelText;
    } else if (self.mode == UseusProgressViewModeCustomView) {
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = self.window.frame;
    CGSize size = self.frame.size;
    CGFloat maxTextLenght = size.width - (80 * 2);
    CGSize strSize = [self sizeWithFrame:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) string:self.labelText font:[UIFont systemFontOfSize:kLabelFontSize]];
    if (strSize.width > maxTextLenght) {
        strSize = [self sizeWithFrame:CGSizeMake(maxTextLenght, CGFLOAT_MAX) string:self.labelText font:[UIFont systemFontOfSize:kLabelFontSize]];
    }
    
    CGFloat width = strSize.width + 20*2;
    CGFloat height = strSize.height + 22*2;
    CGFloat x = (size.width - width)/2;
    CGFloat y = (size.height - height)/2;
    
    self.amazonView.frame = CGRectMake(x, y, width, height);
    
    CGFloat labelW = strSize.width;
    CGFloat labelH = strSize.height;
    CGFloat labelX = (width - labelW)/2;
    CGFloat labelY = (height - labelH)/2;
    self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);
}

-(CGSize)sizeWithFrame:(CGSize)size string:(NSString *)string font:(UIFont *)font {
    if (string == nil) {
        return CGSizeZero;
    }
    
    CGRect rect = [string boundingRectWithSize:size //限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    return rect.size;
}


#pragma mark - KVO

- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"mode", @"customView", @"labelText", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath {
    if ([keyPath isEqualToString:@"mode"] || [keyPath isEqualToString:@"customView"]) {
        [self updateIndicators];
    } else if ([keyPath isEqualToString:@"labelText"]) {
        self.label.text = self.labelText;
    }
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}


- (void)show:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.9;
        } completion:^(BOOL finished) {
            [self setupViews];
        }];
    } else {
        self.alpha = 0.9;
        [self setupViews];
    }
}

- (void)hide:(BOOL)animated {
    if (animated) {
        if (self.superview) {
            [UIView animateWithDuration:0.3 animations:^{
                self.alpha = 0;
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    } else {
        self.alpha = 0;
        [self removeFromSuperview];
    }
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
    });
}

- (void)hideDelayed:(NSNumber *)animated {
    [self hide:[animated boolValue]];
}

@end

