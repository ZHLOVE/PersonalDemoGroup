//
//  SearchListCell.m
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "SearchListCell.h"
#import "UIImageView+AFNetworking.h"
#import "HiTVVideo.h"
#import "VideoDataProvider.h"
#import "CustomView.h"

NSString* const cSearchListCellID = @"SearchListCell";
const CGFloat cSearchListCellHeight = 150;
const CGFloat cSearchTipsCellHeight = 44;

@interface SearchListCell()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorLabel;
@property (nonatomic, strong) CustomView *cornerView;
@property (strong, nonatomic) AFHTTPRequestOperation* operation;
@end

@implementation SearchListCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.thumbnailImageView.layer.cornerRadius = 4;
    self.thumbnailImageView.layer.masksToBounds = YES;
    [self.thumbnailImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.thumbnailImageView.contentMode =  UIViewContentModeScaleAspectFill;
    self.thumbnailImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.thumbnailImageView.clipsToBounds  = YES;
    _cornerView =[[CustomView alloc]initWithFrame:self.thumbnailImageView.frame];
    _cornerView.sizeToWidth = 30.f;
    [self.thumbnailImageView addSubview:_cornerView];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    self.thumbnailImageView.alpha = highlighted? 0.8: 1;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
   
   // [self.thumbnailImageView setImage:[self cutImage:self.thumbnailImageView.image]];

}
- (void)setVideo:(SearchEntity *)video{
    _video = video;
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[video.hlContent dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.titleLabel.attributedText = attrStr;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    if (video.hlContent.length == 0) {
        self.titleLabel.text = video.name;
    }
    [_cornerView useViewCorners:video.cornerArray];
   /* NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:_video.name];
    NSRange range = [_video.name rangeOfString:self.keyword];
    [noteStr addAttribute:NSForegroundColorAttributeName value:kNavColor range:range];
    [self.titleLabel setAttributedText:noteStr] ;
    [self.titleLabel sizeToFit];*/
    
    [self.thumbnailImageView setImageWithURL:[NSURL URLWithString: video.imgUrl] placeholderImage:[UIImage imageNamed:@"loadingImage"]];


    self.directorLabel.text = video.desc;
//    
//    if (video.director != nil && video.actor != nil) {
//        NSString *dirctor = [video.director stringByReplacingOccurrencesOfString:@"|" withString:@" "];
//        NSMutableAttributedString *directorStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"导演 %@", dirctor]];
//        [directorStr addAttributes:@{NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, 2)];
//        self.directorLabel.attributedText = directorStr;
//        NSString *actor = [video.actor stringByReplacingOccurrencesOfString:@"|" withString:@" "];
//        NSMutableAttributedString *actorStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"主演 %@", actor]];
//        [actorStr addAttributes:@{NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, 2)];
//        self.actorLabel.attributedText = actorStr;
//    }else{
//        [self.operation cancel];
//        
//        self.directorLabel.text = @"";
//        self.actorLabel.text = @"";
//        
//        __weak typeof(self) weakSelf = self;
//        self.operation = [[VideoDataProvider sharedInstance] getVideo:video.actionUrl
//                                                           completion:^(id responseObject) {
//                                                               HiTVVideo* video = (HiTVVideo*)responseObject;
//                                                               weakSelf.video.director = video.director;
//                                                               weakSelf.video.actor = video.actor;
//                                                               weakSelf.operation = nil;
//                                                               
//                                                               weakSelf.video = weakSelf.video;
//                                                           } failure:^(NSString *error) {
//                                                               weakSelf.operation = nil;
//                                                           }];
//    }
}
- (UIImage *)cutImage:(UIImage*)image
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (self.thumbnailImageView.size.width / self.thumbnailImageView.size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * self.thumbnailImageView.size.height / self.thumbnailImageView.size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * self.thumbnailImageView.size.width / self.thumbnailImageView.size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}
@end
