
#import "JGProgressHUD.h"
#import "JGProgressHUDErrorIndicatorView.h"
#import "UILoadingView.h"

@interface UILoadingView ()
@property(nonatomic) BOOL isVisible;
@property(nonatomic,strong) JGProgressHUD *loadingView;
@end

@implementation UILoadingView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isVisible = false;
    }
    return self;
}

- (BOOL)Show:(UIViewController *)tar WithString:(NSString *)title inTop:(BOOL)isTop {
    BOOL rtn = false;
    if (!self.isVisible) {
        self.isVisible = true;
        self.loadingView = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.loadingView.layoutChangeAnimationDuration = 0;
        self.loadingView.textLabel.text = (title ? title : @"处理中");
        [self.loadingView showInView:(isTop ? [self topView: tar] : tar.view) animated:NO];
        rtn = true;
    }
    return rtn;
}

- (BOOL)Show:(UIViewController *)tar WithString:(NSString *)title {
    return [self Show:tar WithString:title inTop:true];
}

- (BOOL)ShowAt:(UIViewController *)tar WithString:(NSString *)title {
    return [self Show:tar WithString:title inTop:false];
}

- (void)Hide:(NSString *)title {
    if (nil == title) {
        [self.loadingView dismiss];
        self.isVisible = false;
    } else {
        self.loadingView.indicatorView = [JGProgressHUDErrorIndicatorView new];
        self.loadingView.textLabel.text = title;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.loadingView dismissAnimated:NO];
            self.isVisible = false;
        });
    }
}

- (UIView*)topView:(UIViewController*)viewController {
    UIViewController* recentView = viewController;
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

@end