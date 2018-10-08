//
//  ViewController.m
//  TTPhotoBrowser
//

//  Copyright © 2018年 TTPhotoBrowser. All rights reserved.
//

#import "ViewController.h"
#import "TTPhoto.h"
#import <UIImageView+WebCache.h>


@interface ViewController ()

/**数据源*/
@property(nonatomic,strong)NSMutableArray *itemArray;
/**browser*/
@property(nonatomic,strong)TTPhotoBrowser *photoBrowser;
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://yhmbucket.img-cn-qingdao.aliyuncs.com/supply/upload/img/201806/20073745f7e8218385d6a3617df40982.jpeg"]];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [imageView addGestureRecognizer:tap];
    
    TTPhotoItem *item1 = [[TTPhotoItem alloc] init];
    item1.url = @"http://yhmbucket.img-cn-qingdao.aliyuncs.com/supply/upload/img/201712/472c6e2018c9aac144eb6445216b8bfe.jpeg";
    item1.placeIamgeUrl = @"http://yhmbucket.img-cn-qingdao.aliyuncs.com/supply/upload/img/201806/20073745f7e8218385d6a3617df40982.jpeg";
    [self.itemArray addObject:item1];

    TTPhotoItem *item2 = [[TTPhotoItem alloc] init];
    item2.placeIamgeUrl = @"http://yhmbucket.img-cn-qingdao.aliyuncs.com/supply/upload/img/201712/472c6e2018c9aac144eb6445216b8bfe.jpeg";
    item2.url = @"http://yhmbucket.img-cn-qingdao.aliyuncs.com/supply/upload/img/201806/20073745f7e8218385d6a3617df40982.jpeg";
    [self.itemArray addObject:item2];
}
    
-(NSMutableArray *)itemArray{
    if (_itemArray == nil) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    return _itemArray;
}
    
-(void)tapAction{
    TTPhotoBrowser *brower = [[TTPhotoBrowser alloc]init];
    brower.itemsArray = self.itemArray;
    brower.currentIndex = 0;
    self.photoBrowser = brower;
    [self.photoBrowser present];
}


@end
