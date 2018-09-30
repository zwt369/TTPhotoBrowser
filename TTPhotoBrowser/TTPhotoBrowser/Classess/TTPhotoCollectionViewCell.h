//
//  TTPhotoCollectionViewCell.h
//  TTPhotoBrowser
//
//  Created by 壹号美 on 2018/9/30.
//  Copyright © 2018年 TTPhotoBrowser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPhotoImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPhotoCollectionViewCell : UICollectionViewCell

/**轻点block */
@property (nonatomic,copy)void(^tapBlock)(void);
/** 长按block */
@property (nonatomic,copy)void(^longPressBlock)(void);
    
- (void)sd_ImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder;
    
@end

NS_ASSUME_NONNULL_END
