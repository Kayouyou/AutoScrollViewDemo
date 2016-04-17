//
//  ADScrollViewComponent.h
//  ADScrollView
//
//  Created by 叶杨杨 on 16/4/17.
//  Copyright © 2016年 叶杨杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+WebCacheOperation.h"
#import "UIImageView+WebCache.h"
/**
 *  趁有空，封装的一个自动加手动滚播的广告页面，基于UIScrollView，便于开发效率
 */

#define ColorWithRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

/**
 *  block 回调
 *
 *  @param index 返回对应广告图片的下标
 */
typedef void (^adImageClickCallBack)(NSInteger index);



@interface ADScrollViewComponent : UIView

/**
 *  轮播广告的scrollView
 */
@property (nonatomic, strong) UIScrollView *adScrollView;

/**
 *  轮播的页码
 */
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 *  轮播的时间
 */
@property (nonatomic, assign) CGFloat time;

/**
 *  静态的初始化轮播控件的方法
 *
 *  @param frame    轮播的大小
 *  @param images   轮播的图片数量
 *  @param callBack 响应点击图片的回调
 *
 *  @return 返回一个初始化的轮播控件
 */
+ (instancetype)adScrollViewWithFrame:(CGRect)frame imageItems:(NSArray *)images
                andImageClickCallBack:(adImageClickCallBack)callBack;


/**
 *  开始定时器
 */
- (void)startScroTimer;
/**
 *  关闭定时器
 */
- (void)stopScroTimer;







@end
