//
//  AttachedFileHeader.m
//  SelfService
//
//  created by iSwift on 12/25/13.
//  Copyright (c) 2013 Exigen Insurance Solutions. All rights reserved.
//

#import "VideoCategoryHeader.h"
#import "VideoCategoryDetailViewController.h"
#import "VideoCategoryDetailCollectionViewController.h"

NSString * const cVideoCategoryHeaderID = @"VideoCategoryHeader";

@interface VideoCategoryHeader()

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel* more;

@end

@implementation VideoCategoryHeader

- (void)setVideoCategory:(VideoCategory *)videoCategory{
    _videoCategory = videoCategory;
    self.titleLabel.text = videoCategory.name;
}

- (IBAction)buttonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:[HiTVConstants HiTVConstantsShowViewControllerNotificationName]
     object:self
     userInfo:@{[HiTVConstants HiTVConstantsShowViewControllerNotificationController]: [[VideoCategoryDetailViewController alloc] initWithVideoCategory:self.videoCategory]}];
}

@end
