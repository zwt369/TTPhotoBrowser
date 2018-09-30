//
//  TTPhotoCollectionViewCell.m
//  TTPhotoBrowser
//
//  Created by 壹号美 on 2018/9/30.
//  Copyright © 2018年 TTPhotoBrowser. All rights reserved.
//

#import "TTPhotoCollectionViewCell.h"

@implementation TTPhotoCollectionViewCell{
    TTPhotoImageView *photoImageView;
}
    
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupImageView];
    }
    return self;
}
    
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
    }
    return self;
}
    
- (void)setupImageView{
    __weak __typeof(self) weakSelf = self;
    TTPhotoImageView *photoBrowerView = [[TTPhotoImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    photoBrowerView.tapBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        if(strongSelf.tapBlock){
            strongSelf.tapBlock();
        }
    };
    photoBrowerView.longPressBlock = ^(){
        __strong typeof(self) strongSelf = weakSelf;
        if(strongSelf.longPressBlock){
            strongSelf.longPressBlock();
        }
    };
    photoImageView = photoBrowerView;
    [self.contentView addSubview:photoBrowerView];
}
    
- (void)sd_ImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder{
    [photoImageView sd_ImageWithUrl:[NSURL URLWithString:url] placeHolder:placeHolder];
}
    
- (void)prepareForReuse{
    [photoImageView.scrollView setZoomScale:1.f animated:NO];
}

    
@end
