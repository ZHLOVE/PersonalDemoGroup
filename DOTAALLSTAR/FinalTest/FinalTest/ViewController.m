#import "ViewController.h"

@import Safelight;


@interface ViewController () <SafelightDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *specSegment;

@end


@implementation ViewController

- (IBAction)alert:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hi there"
                                                                   message:@"You triggered an alert!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)go:(id)sender {
    self.imageView.image = nil;
    
#define PRODUCTION 1
#if PRODUCTION
    NSString *APP_KEY = @"9035da24ab304efdb4be216e0f4cf6e9";
    NSString *APP_SECRET = @"65adb17ca0254fec841cc0b25a83a6b2";
#else
    NSString *APP_KEY = @"0c423ba2a06a4f79904c12b55ecec225";
    NSString *APP_SECRET = @"e91bff2818c0475e92604bb025a8bc45";
#endif
    
    static char const *specKeys[] = {
        "a2c4c3d753ba40ed8b3c61c352312a2d",
        "12253adaf5b24c6c985c61606c07939f",
    };
    
    NSString *specKey = [NSString stringWithUTF8String:specKeys[self.specSegment.selectedSegmentIndex]];
//    参考文档指定背景颜色16进制
    UIColor *beginColor = [UIColor whiteColor];
    UIColor *endColor = [UIColor whiteColor];


    
    [Safelight makeWithKey:APP_KEY
                    secret:APP_SECRET
                   specKey:specKey
                beginColor:beginColor
                  endColor:endColor
            viewController:self
                  delegate:self];
}

- (void)safelightFinishedWithImage:(UIImage *)image score:(NSInteger)score
{
    NSLog(@"Success");
    NSLog(@"平均得分===%ld",(long)score);
    self.imageView.image = image;
}

- (void)safelightFinishedWithError:(NSError *)error
{
    BOOL isSafelightError = [error.domain isEqualToString:[Safelight errorDomain]];
    if (isSafelightError && error.code == -1001) {
        NSLog(@"用户主动取消了操作");
    } else {
        NSLog(@"Failed %d: %@", error.code, [error localizedDescription]);
    }
}

@end

