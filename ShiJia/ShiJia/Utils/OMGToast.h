
#import <Foundation/Foundation.h> 
#import <UIKit/UIKit.h>
  
#define DEFAULT_DISPLAY_DURATION 1.5f  
  
@interface OMGToast : UIView {
    NSString *text;  
    UIButton *contentView;  
    CGFloat  duration;  
}  

+ (void)showWithText:(NSString *) text_;  
+ (void)showWithText:(NSString *) text_  
            duration:(CGFloat)duration_;  

+ (void)showWithText:(NSString *) text_  
           topOffset:(CGFloat) topOffset_;  
+ (void)showWithText:(NSString *) text_  
           topOffset:(CGFloat) topOffset  
            duration:(CGFloat) duration_;  

+ (void)showWithText:(NSString *) text_  
        bottomOffset:(CGFloat) bottomOffset_;  
+ (void)showWithText:(NSString *) text_  
        bottomOffset:(CGFloat) bottomOffset_  
            duration:(CGFloat) duration_;

+ (void)showWithNumText:(NSString *) text_;

@end  
