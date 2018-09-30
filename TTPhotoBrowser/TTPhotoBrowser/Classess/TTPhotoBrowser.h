//
//  TTPhotoBrowser.h
//  TTPhotoBrowser
//
//  Created by 壹号美 on 2018/9/30.
//  Copyright © 2018年 TTPhotoBrowser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPhotoItem.h"

@protocol TTPhotoBrowerDelegate <NSObject>
    
@optional
/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss;
/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success;
/* PhotoBrower 删除图片成功后返回-- > 相对 Index */
- (void)photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index;
/* PhotoBrower 删除图片成功后返回-- > 绝对 Index */
- (void)photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index;
/* 二维码扫描结果 */
- (void)qrCordScanResult:(NSString *)result;
    
@end


NS_ASSUME_NONNULL_BEGIN

@interface TTPhotoBrowser : UIView

/**当前图片的下标*/
@property (nonatomic, assign) NSInteger currentIndex;
/**是否打开长按功能*/
@property (nonatomic, assign) BOOL openLongPress;
/**存放图片的模型 :url && UIView*/
@property (nonatomic, strong) NSArray *itemsArr;
/**存放 ActionSheet 弹出框的内容 :NSString类型*/
@property (nonatomic, strong) NSMutableArray *actionSheetArr;
/**是否需要 底部 UIPageControl, Default is YES*/
@property (nonatomic, assign) BOOL isNeedPageControl;
/**为 collectionView 循环利用所 提供的 父控件*/
@property (nonatomic, weak) UIView *sourceViewForCellReusable;

/**
 *  为 collectionView 没有 展现出来的 image 做准备(Demo中会写出 如何使用) --> 类似 自己朋友圈中的图片浏览
 *  所有url的数组 --> 为 collectionView 所做的全部 url 数组 (如果这个参数设置有数据, 那么就当 collectionView 处理)
 */
@property (nonatomic, strong) NSArray *dataSourceUrlArr;

@property (nonatomic, weak ) id<TTPhotoBrowerDelegate> delegate;

- (void)present;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
