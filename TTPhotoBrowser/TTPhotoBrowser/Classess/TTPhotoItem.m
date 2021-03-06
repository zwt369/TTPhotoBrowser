//
//  TTPhotoItem.m
//  TTPhotoBrowser
//

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
            _placeIamge = [UIImage imageNamed:@"TTPhotoBrower.bundle/defaultPlaceHolder"];
        }
    }
    return _placeIamge;
}

@end
