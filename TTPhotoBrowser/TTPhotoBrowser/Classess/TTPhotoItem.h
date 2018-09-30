//
//  TTPhotoItem.h
//  TTPhotoBrowser
//

//  Copyright © 2018年 TTPhotoBrowser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTPhotoItem : NSObject

/**如果是网络图片,则设置url.不设置 sourceImage*/
@property (nonatomic, copy  ) NSString *url;
    
/**占位图*/
@property (nonatomic, copy) NSString *placeIamgeUrl;
@property (nonatomic, strong) UIImage *placeIamge;

/** 如果加载 本地图片, url 则不可以赋值,*/
@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, strong) UIView *sourceView;
    
@end

NS_ASSUME_NONNULL_END
