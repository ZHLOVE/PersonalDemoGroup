//
//  PageViewController.m
//  HiTV
//
//  Created by lanbo zhang on 9/26/15.
//  Copyright © 2015 Lanbo Zhang. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (void) setViewControllers:(NSArray*)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    
    if (!animated
        || [self.viewControllers isEqual:viewControllers]) {
        [super setViewControllers:viewControllers direction:direction animated:NO completion:completion];
        return;
    }
    
    @try {
        [super setViewControllers:viewControllers direction:direction animated:YES completion:^(BOOL finished){
            
            if (finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [super setViewControllers:viewControllers direction:direction animated:NO completion:completion];
                });
            } else {
                if (completion != NULL) {
                    completion(finished);
                }
            }
        }];
    }
    @catch (NSException *exception) {
        DDLogError(@"crashed: %@", exception);
    }
    @finally {
        
    }
}


@end
