
#import <UIKit/UIKit.h>

@interface UILoadingView : UIView
- (BOOL)Show:(UIViewController *)tar WithString:(NSString *)title;
- (BOOL)ShowAt:(UIViewController *)tar WithString:(NSString *)title;
- (void)Hide:(NSString *)title;
@end
