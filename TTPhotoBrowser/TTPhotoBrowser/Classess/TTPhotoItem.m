//
//  TTPhotoItem.m
//  TTPhotoBrowser
//
//  Created by 壹号美 on 2018/9/30.
//  Copyright © 2018年 TTPhotoBrowser. All rights reserved.
//

#import "TTPhotoItem.h"

@implementation TTPhotoItem

-(UIImage *)placeIamge{
    if (_placeIamge == nil) {
        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
        if ([[mgr imageCache] imageFromDiskCacheForKey:self.placeIamgeUrl] != nil) {
            _placeIamge = [[mgr imageCache] imageFromDiskCacheForKey:self.placeIamgeUrl];
        }else{
            _placeIamge = [UIImage imageNamed:@"KNPhotoBrower.bundle/defaultPlaceHolder"];
        }
    }
    return _placeIamge;
}

@end
