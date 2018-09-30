//
//  TTPhotoImageView.h
//  TTPhotoBrowser
//

//  Copyright © 2018年 TTPhotoBrowser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

#ifndef ScreenWidth
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef ScreenHeight
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

NS_ASSUME_NONNULL_BEGIN

@interface TTPhotoImageView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;

/**轻点block */
@property (nonatomic,copy)void(^tapBlock)(void);
/** 长按block */
@property (nonatomic,copy)void(^longPressBlock)(void);
    
- (void)sd_ImageWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder;
    
- (void)reloadFrames;
    
@end

NS_ASSUME_NONNULL_END
