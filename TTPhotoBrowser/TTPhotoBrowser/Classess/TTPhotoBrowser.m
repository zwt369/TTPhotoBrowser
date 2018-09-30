//
//  TTPhotoBrowser.m
//  TTPhotoBrowser
//

//  Copyright © 2018年 TTPhotoBrowser. All rights reserved.
//

#import "TTPhotoBrowser.h"
#import "TTPhotoCollectionViewCell.h"

@interface TTPhotoBrowser()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;
    
@property (nonatomic, assign)BOOL isFirstShow;
    
@property (nonatomic, assign)CGFloat contentOffsetX;
    
@property (nonatomic, assign)NSInteger page;
    
@property (nonatomic, strong)NSArray *tempArr;
    
@property (nonatomic, strong)UIPageControl *pageControl;
    
@end

static NSString *ID = @"KNCollectionView";


@implementation TTPhotoBrowser

- (instancetype)init{
    if (self = [super init]) {
        self.openLongPress = YES;
        self.isNeedPageControl = YES;
        [self initializeDefaultProperty];
    }
    return self;
}

#pragma mark - 初始化 基本属性
- (void)initializeDefaultProperty{
    [self setBackgroundColor:[UIColor blackColor]];
    self.actionSheetArr = [NSMutableArray array];
}

#pragma mark - 初始化 CollectionView
- (void)initializeCollectionView{
    CGRect bounds = (CGRect){{0,0},{self.frame.size.width,self.frame.size.height}};
    bounds.size.width += 20;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:bounds.size];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:bounds collectionViewLayout:layout];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [collectionView setPagingEnabled:YES];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [collectionView setDecelerationRate:0];
    [collectionView registerClass:[TTPhotoCollectionViewCell class] forCellWithReuseIdentifier:ID];
    self.collectionView = collectionView;
    [self addSubview:collectionView];
}

#pragma mark - 初始化 UIPageControl
- (void)initializePageControl{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [pageControl setCurrentPage:self.currentIndex];
    [pageControl setNumberOfPages:_itemsArray.count];
    [pageControl setFrame:(CGRect){{0,ScreenHeight - 50},{ScreenWidth,30}}];
    [pageControl setHidden:!_isNeedPageControl];
    if(_itemsArray.count == 1){
        [pageControl setHidden:YES];
    }
    self.pageControl = pageControl;
    [self addSubview:pageControl];
}


#pragma mark - 长按点击事件
- (void)operationAction{
//__weak __typeof(self) weakSelf = self;
//if(_actionSheetArr.count != 0){ // 如果是自定义的 选项
//    KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelBtnTitle:nil destructiveButtonTitle:nil otherBtnTitlesArr:[weakSelf.actionSheetArr copy] actionBlock:^(NSInteger buttonIndex) {
//        // 让代理知道 是哪个按钮被点击了
//        if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationActionWithIndex:)]){
//            [weakSelf.delegate photoBrowerRightOperationActionWithIndex:buttonIndex selectedIndex:self.currentIndex];
//        }
//    }];
//    [actionSheet show];
//}else{
//    UIImageView *imageView = [self tempViewFromSourceViewWithCurrentIndex:self.currentIndex];
//    BOOL contentCRCode = NO;
//    NSString *featureString;
//    if (imageView.image != nil) {
//        CGSize rawSize = imageView.image.size;
//        UIImage *newImage = [imageView.image imageScaleToSize:CGSizeMake(256, 256*rawSize.height/rawSize.width)];
//        CIContext *context = [CIContext contextWithOptions:nil];
//        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
//        CIImage *image = [CIImage imageWithCGImage:newImage.CGImage];
//        NSArray *features = [detector featuresInImage:image];
//        CIQRCodeFeature *feature = [features firstObject];
//        featureString = feature.messageString;
//        if (featureString.length) {
//            contentCRCode = YES;
//        }
//    }
//    if (self.openCollection) {
//        NSArray *countArray;
//        if (contentCRCode) {
//            countArray = @[@"保存图片",@"收藏",@"识别图中的二维码"];
//        }else{
//            countArray = @[@"保存图片",@"收藏"];
//        }
//        KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelBtnTitle:nil destructiveButtonTitle:@"发送给朋友" otherBtnTitlesArr:countArray actionBlock:^(NSInteger buttonIndex) {
//            if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationActionWithIndex:selectedIndex:)]){
//                [weakSelf.delegate photoBrowerRightOperationActionWithIndex:buttonIndex selectedIndex:self.currentIndex];
//            }
//            switch (buttonIndex) {
//                case 0:{ // 删除图片
//
//                }
//                break;
//                case 1:{ // 下载图片
//                    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//                    if (status == PHAuthorizationStatusRestricted ||
//                        status == PHAuthorizationStatusDenied) {
//                        //无权限
//                        [[UIApplication sharedApplication].keyWindow showMbProgressHUDMessage:@"无相册访问权限，请先开启权限"];
//                        return ;
//                    }
//                    KNPhotoItems *items = weakSelf.itemsArray[weakSelf.currentIndex];
//                    if(items.url){ // 如果是网络图片
//                        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
//                        [mgr diskImageExistsForURL:[NSURL URLWithString:items.url] completion:^(BOOL isInCache) {
//                            if (isInCache) {
//                                UIImage *image = [[mgr imageCache] imageFromDiskCacheForKey:items.url];
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//                                });
//                            }else{
//                                [[KNToast shareToast] initWithText:PhotoSaveImageFailureReason];
//                            }
//                        }];
//                    }else{ // 如果是本地图片
//                        UIImageView *imageView = [self tempViewFromSourceViewWithCurrentIndex:self.currentIndex];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//                        });
//                    }
//                }
//                break;
//                case 3:{
//                    if (contentCRCode) {
//                        if ([weakSelf.delegate respondsToSelector:@selector(qrCordScanResult:)]) {
//                            [weakSelf.delegate qrCordScanResult:featureString];
//                        }
//                    }
//                }
//                break;
//
//                /**
//                 *  剩下的需要自己去实现
//                 */
//                default:
//
//                break;
//            }
//        }];
//        [actionSheet show];
//        return;
//    }else if (self.closeTransmit){
//
//        KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelBtnTitle:nil destructiveButtonTitle:@"保存图片" otherBtnTitlesArr:nil actionBlock:^(NSInteger buttonIndex) {
//            if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationActionWithIndex:selectedIndex:)]){
//                [weakSelf.delegate photoBrowerRightOperationActionWithIndex:buttonIndex selectedIndex:self.currentIndex];
//            }
//
//            switch (buttonIndex) {
//                case 0:{ // 下载图片
//#pragma mark - 下载图片
//                    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//                    if (status == PHAuthorizationStatusRestricted ||
//                        status == PHAuthorizationStatusDenied) {
//                        //无权限
//                        [[UIApplication sharedApplication].keyWindow showMbProgressHUDMessage:@"无相册访问权限，请先开启权限"];
//                        return ;
//                    }
//                    KNPhotoItems *items = weakSelf.itemsArray[weakSelf.currentIndex];
//                    if(items.url){ // 如果是网络图片
//                        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
//                        [mgr diskImageExistsForURL:[NSURL URLWithString:items.url] completion:^(BOOL isInCache) {
//                            if (isInCache) {
//                                UIImage *image = [[mgr imageCache] imageFromDiskCacheForKey:items.url];
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//                                });
//                            }else{
//                                [[KNToast shareToast] initWithText:PhotoSaveImageFailureReason];
//                            }
//                        }];
//                    }else{ // 如果是本地图片
//                        UIImageView *imageView = [self tempViewFromSourceViewWithCurrentIndex:self.currentIndex];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//                        });
//                    }
//                }
//                break;
//                /**
//                 *  剩下的需要自己去实现
//                 */
//                default:
//
//                break;
//            }
//        }];
//        [actionSheet show];
//        return;
//    }
//    NSArray *countArray;
//    if (contentCRCode) {
//        countArray = @[@"保存图片",@"识别图中的二维码"];
//    }else{
//        countArray = @[@"保存图片"];
//    }
//    KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelBtnTitle:nil destructiveButtonTitle:@"发送给朋友" otherBtnTitlesArr:countArray actionBlock:^(NSInteger buttonIndex) {
//        //        KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelBtnTitle:nil destructiveButtonTitle:@"发送给朋友" otherBtnTitlesArr:@[@"保存图片"] actionBlock:^(NSInteger buttonIndex) {
//        // 让代理知道 是哪个按钮被点击了
//        if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationActionWithIndex:selectedIndex:)]){
//            [weakSelf.delegate photoBrowerRightOperationActionWithIndex:buttonIndex selectedIndex:self.currentIndex];
//        }
//
//        switch (buttonIndex) {
//            case 0:{ // 删除图片
//#pragma mark - 删除图片
//                //                    // 0: 删除后 回调返回 相对 下标
//                //                    if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:)]){
//                //                        [weakSelf.delegate photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:weakSelf.currentIndex];
//                //                    }
//                //
//                //                    KNPhotoItems *items = _itemsArray[self.currentIndex];
//                //                    NSInteger index = [tempArr indexOfObject:items];
//                //                    // 1: 删除后 回调返回 绝对 下标
//                //                    if([weakSelf.delegate respondsToSelector:@selector(photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:)]){
//                //                        [weakSelf.delegate photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:index];
//                //                    }
//                //
//                //                    [weakSelf deleteImageIBAction];
//            }
//            break;
//            case 1:{ // 下载图片
//#pragma mark - 下载图片
//                PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//                if (status == PHAuthorizationStatusRestricted ||
//                    status == PHAuthorizationStatusDenied) {
//                    //无权限
//                    [[UIApplication sharedApplication].keyWindow showMbProgressHUDMessage:@"无相册访问权限，请先开启权限"];
//                    return ;
//                }
//                KNPhotoItems *items = weakSelf.itemsArray[weakSelf.currentIndex];
//                if(items.url){ // 如果是网络图片
//                    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
//                    [mgr diskImageExistsForURL:[NSURL URLWithString:items.url] completion:^(BOOL isInCache) {
//                        if (isInCache) {
//                            UIImage *image = [[mgr imageCache] imageFromDiskCacheForKey:items.url];
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//                            });
//                        }else{
//                            [[KNToast shareToast] initWithText:PhotoSaveImageFailureReason];
//                        }
//                    }];
//                }else{ // 如果是本地图片
//                    UIImageView *imageView = [self tempViewFromSourceViewWithCurrentIndex:self.currentIndex];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//                    });
//                }
//            }
//            break;
//            case 2:{
//                if (contentCRCode) {
//                    if ([weakSelf.delegate respondsToSelector:@selector(qrCordScanResult:)]) {
//                        [weakSelf.delegate qrCordScanResult:featureString];
//                    }
//                }
//            }
//            break;
//            /**
//             *  剩下的需要自己去实现
//             */
//            default:
//            break;
//        }
//    }];
//    [actionSheet show];
//}
}

#pragma mark - 将相片存入相册, 只回调这个方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(!error){
//        [[KNToast shareToast] initWithText:PhotoSaveImageSuccessMessage duration:PhotoSaveImageMessageTime];
    }else{
//        [[KNToast shareToast] initWithText:PhotoSaveImageFailureMessage duration:PhotoSaveImageMessageTime];
    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _itemsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf = self;
    TTPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    TTPhotoItem *items = _itemsArray[indexPath.row];
    NSString *url = items.url;
    [cell sd_ImageWithUrl:url placeHolder:items.placeIamge];
    cell.tapBlock = ^(){
        [weakSelf dismiss];
    };
    cell.longPressBlock = ^(){
        if (weakSelf.openLongPress) {
            [weakSelf operationAction];
        }
    };
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
    
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.currentIndex = scrollView.contentOffset.x / (ScreenWidth + 20);
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    NSInteger currentPage = (x + scrollViewW / 2) / scrollViewW;
    if(self.page != currentPage){
        self.page = currentPage;
        if(self.page + 1 <= _itemsArray.count){
            [self.pageControl setCurrentPage:self.page];
        }
    }
}

#pragma mark - 移到父控件上
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self initializeCollectionView];
    [self initializePageControl];
}

#pragma mark - 展现
- (void)present{
    if([self imageArrayIsEmpty:_itemsArray]){
        return;
    }
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (!self.operationArray) {
        self.openLongPress = NO;
    }
    if(![self imageArrayIsEmpty:_dataSourceUrlArr]){
        NSArray *arr = [_dataSourceUrlArr subarrayWithRange:NSMakeRange(_itemsArray.count, _dataSourceUrlArr.count -_itemsArray.count)];
        NSMutableArray *Arrs = [NSMutableArray arrayWithArray:_itemsArray];
        [Arrs addObjectsFromArray:arr];
        _itemsArray = [Arrs copy];
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self setFrame:window.bounds];
    [window addSubview:self];
}

#pragma mark - 展现没有动画
- (void)presentWithoutAnimation{
    if([self imageArrayIsEmpty:_itemsArray]){
        return;
    }
    self.isFirstShow = YES;
    if(![self imageArrayIsEmpty:_dataSourceUrlArr]){
        NSArray *arr = [_dataSourceUrlArr subarrayWithRange:NSMakeRange(_itemsArray.count, _dataSourceUrlArr.count -_itemsArray.count)];
        NSMutableArray *Arrs = [NSMutableArray arrayWithArray:_itemsArray];
        [Arrs addObjectsFromArray:arr];
        _itemsArray = [Arrs copy];
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self setFrame:window.bounds];
    [window addSubview:self];
}

#pragma mark - 消失
- (void)dismiss{
    UIImageView *tempView = [[UIImageView alloc] init];
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    TTPhotoItem *items = _itemsArray[self.currentIndex];
    [mgr diskImageExistsForURL:[NSURL URLWithString:items.url] completion:^(BOOL isInCache) {
        if (isInCache) {
            if ([items.url hasSuffix:@".gif"]) {
                NSData *data = UIImageJPEGRepresentation([[mgr imageCache] imageFromDiskCacheForKey:items.url], 1.f);
                tempView.image = [self imageFromGifFirstImage:data]; // 获取图片的第一帧
            }else{
                tempView.image = [[mgr imageCache] imageFromDiskCacheForKey:items.url];
            }
        }else{
            UIImage *image = [[self tempViewFromSourceViewWithCurrentIndex:self.currentIndex] image];
            if(image){
                [tempView setImage:image];
            }else{
                [tempView setImage:items.sourceImage];
            }
        }
    }];
    if(!tempView.image){
        tempView.image = items.placeIamge;
    }
    [self.collectionView setHidden:YES];
    [self.pageControl    setHidden:YES];
    self.tempArr = nil;
    UIView *sourceView;
    if([_sourceViewForCellReusable isKindOfClass:[UICollectionView class]]){
        sourceView = [(UICollectionView *)_sourceViewForCellReusable cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    }else{
        sourceView = items.sourceView;
    }
    CGRect rect = [sourceView convertRect:[sourceView bounds] toView:self];
    if(rect.origin.y > ScreenHeight ||
       rect.origin.y <= - rect.size.height ||
       rect.origin.x > ScreenWidth ||
       rect.origin.x <= -rect.size.width
       ){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [tempView removeFromSuperview];
            [self setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        return;
    }else{
        CGFloat width  = tempView.image.size.width;
        CGFloat height = tempView.image.size.height;
        CGSize tempRectSize = (CGSize){ScreenWidth,(height * ScreenWidth / width) > ScreenHeight ? ScreenHeight:(height * ScreenWidth / width)};
        [tempView setBounds:(CGRect){CGPointZero,{tempRectSize.width,tempRectSize.height}}];
        [tempView setCenter:[self center]];
        [self addSubview:tempView];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [tempView setFrame:rect];
            [self setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - 展现的时候 动画
- (void)photoBrowerWillShowWithAnimated{
    // 0.初始化绝对数据源
    self.tempArr = [NSArray arrayWithArray:_itemsArray];
    // 1.判断用户 点击了的控件是 控制器中的第几个图片. 在这里设置 collectionView的偏移量
    [self.collectionView setContentOffset:(CGPoint){self.currentIndex * (self.frame.size.width + 20),0} animated:NO];
    self.contentOffsetX = self.collectionView.contentOffset.x;
    // 2. 可能考虑到 self.sourceView上面放着的是: 'button' ,所以这里用 UIView去接收
    TTPhotoItem *items = _itemsArray[self.currentIndex];
    // 将 sourView的frame 转到 self上, 获取到 frame
    UIView *sourceView;
    if([_sourceViewForCellReusable isKindOfClass:[UICollectionView class]]){
        sourceView = [(UICollectionView *)_sourceViewForCellReusable cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    }else{
        sourceView = items.sourceView;
    }
    CGRect rect = [sourceView convertRect:[sourceView bounds] toView:self];
    UIImageView *tempView = [self tempViewFromSourceViewWithCurrentIndex:self.currentIndex];
    [tempView setFrame:rect];
    [tempView setCenter:[self center]];
    [tempView setContentMode:sourceView.contentMode];
    [self addSubview:tempView];
    CGSize tempRectSize;
    CGFloat width = tempView.image.size.width;
    CGFloat height = tempView.image.size.height;
    tempRectSize = (CGSize){ScreenWidth,(height * ScreenWidth / width) > ScreenHeight ? ScreenHeight:(height * ScreenWidth / width)};
    [self.collectionView setHidden:YES];
    if (self.isFirstShow) {
        [self.collectionView setHidden:NO];
    }else{
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [tempView setCenter:[self center]];
            [tempView setBounds:(CGRect){CGPointZero,tempRectSize}];
        } completion:^(BOOL finished) {
            self.isFirstShow = YES;
            [tempView removeFromSuperview];
            [self.collectionView setHidden:NO];
        }];
    }
}

#pragma mark - 获取到 GIF图片的第一帧
- (UIImage *)imageFromGifFirstImage:(NSData *)data{
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *sourceImage;
    if(count <= 1){
        CFRelease(source);
        sourceImage = [[UIImage alloc] initWithData:data];
    }else{
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        sourceImage = [UIImage imageWithCGImage:image];
        CFRelease(source);
        CGImageRelease(image);
    }
    return sourceImage;
}

#pragma mark 私有方法 : 将子控件上的控件 转成 ImageView
- (UIImageView *)tempViewFromSourceViewWithCurrentIndex:(NSInteger)currentIndex{
    // 生成临时的一个 imageView 去做 动画
    UIImageView *tempView = [[UIImageView alloc] init];
    TTPhotoItem *items = _itemsArray[currentIndex];
    if([items.sourceView isKindOfClass:[UIImageView class]]){
        UIImageView *imgV = (UIImageView *)items.sourceView;
        [tempView setImage:[imgV image]];
    }
    if([items.sourceView isKindOfClass:[UIButton class]]){
        UIButton *btn = (UIButton *)items.sourceView;
        [tempView setImage:[btn currentBackgroundImage]?[btn currentBackgroundImage]:[btn currentImage]];
    }
    if([self imageArrayIsEmpty:_dataSourceUrlArr]){
        if(!tempView.image){
            [tempView setImage:items.placeIamge];
        }
    }else{
        if([_sourceViewForCellReusable isKindOfClass:[UICollectionView class]]){
            UICollectionViewCell *cell = [(UICollectionView *)_sourceViewForCellReusable cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
            tempView.image = [(UIImageView *)cell.contentView.subviews[0] image];
        }

        if(!tempView.image){
            if(items.sourceImage && !items.url){
                tempView.image = items.sourceImage;
            }else{
                tempView.image = nil;
            }
        }
    }
    return tempView;
}

// 判断 imageUrl数组是否为空
- (BOOL)imageArrayIsEmpty:(NSArray *)array{
    if(array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0){
        return YES;
    }else{
        return NO;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self photoBrowerWillShowWithAnimated];
}

- (void)dealloc{

}


@end
