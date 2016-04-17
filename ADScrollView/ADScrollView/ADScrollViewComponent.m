//
//  ADScrollViewComponent.m
//  ADScrollView
//
//  Created by 叶杨杨 on 16/4/17.
//  Copyright © 2016年 叶杨杨. All rights reserved.
//

#import "ADScrollViewComponent.h"

#define contentOffSet_x self.adScrollView.contentOffset.x
#define frame_width self.adScrollView.frame.size.width
#define contentSize_w self.adScrollView.contentSize.width


@interface ADScrollViewComponent()<UIScrollViewDelegate>
{
    
    /**
     *  imagreView的数组
     */
    NSArray *_viewArr;
    /**
     *  一个控制滚动速度的全局计时器
     */
    NSTimer *_scroTimer;
    /**
     *  点击图片的回调
     */
    adImageClickCallBack _imageClickCallBack;
    
}
/**
 *  广告图片的数组
 */

@property (nonatomic ,strong) NSArray *imageArr;
@end

@implementation ADScrollViewComponent

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
                andImageClickCallBack:(adImageClickCallBack)callBack{
    
    return [[ADScrollViewComponent alloc]initWithFrame:frame imageItems:images andImageClickCallBack:callBack];
    
}

/**
 *  默认的初始化方法
 *
 */
- (instancetype)initWithFrame:(CGRect)frame imageItems:(NSArray *)images
        andImageClickCallBack:(adImageClickCallBack)callBack {
    
    if (self = [self initWithFrame:frame]) {
        
        self.adScrollView.contentSize = CGSizeMake((images.count + 2)*frame_width , 0);
        
        self.pageControl.numberOfPages = images.count;
        
        self.imageArr = images;
        
        _imageClickCallBack = callBack;
        
    }
    
    return self;
}
/**
 *  重写此方法
 *
 *
 *  @return 自定义初始化的scrollView
 */
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.adScrollView = [[UIScrollView alloc]init];
        self.adScrollView.delegate = self;
        self.adScrollView.pagingEnabled = YES;
        self.adScrollView.frame = self.bounds;
        self.adScrollView.scrollsToTop = NO;
        self.adScrollView.contentOffset = CGPointMake(frame_width, 0);
        self.adScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.adScrollView];
        
        self.pageControl = [[UIPageControl alloc]init];
        self.pageControl.frame = CGRectMake(0, self.frame.size.height - 30, frame_width, 30);
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:102/255.0 green:51/255.0 blue:0/255.0 alpha:1];
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:self.pageControl];
        
        self.time = 3.0;
        
        
        
    }
    
    return self;
}

- (void)setTime:(CGFloat)time{
    
    if (time > 0) {
        
        _time = time;
        [self stopScroTimer];
        [self startScroTimer];
    }
}

- (void)setImageArr:(NSArray *)imageArr{

    _imageArr = imageArr;
    
    [self addADImages];
    
    [self startScroTimer];
    
}

- (void)addADImages{
    
    NSMutableArray *imgArr = [NSMutableArray arrayWithArray:self.imageArr];
    //在数组的第一和最末分别添加一个图片
    [imgArr insertObject:[self.imageArr lastObject] atIndex:0];
    [imgArr addObject:[self.imageArr firstObject]];
   // NSLog(@"imagearr  %@",_imageArr);
    NSInteger tag = -1;
    if (imgArr.count == 0) {
        
        return;
    }
    for (NSString *name in imgArr) {
      
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
        
        imgView.frame = CGRectMake(self.frame.size.width * (tag + 1), 0, self.frame.size.width, self.frame.size.height);
        
        if (imgView.image == nil) {
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:nil];
        }
        
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        
        imgView.userInteractionEnabled = YES;
        
        [imgView addGestureRecognizer:tap];
        
        [self.adScrollView addSubview:imgView];
        
        imgView.tag = tag;
        tag ++;
    }
    
    self.pageControl.numberOfPages = self.imageArr.count;

}

- (void)imageClick:(UITapGestureRecognizer *)tap {
    
    UIView *view = tap.view;
    
    if (_imageClickCallBack) {
        
        _imageClickCallBack(view.tag);
    }
}


/**
 *  开始定时器
 */
- (void)startScroTimer{
    
    if (_scroTimer == nil) {
        
        _scroTimer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(timerSel) userInfo:nil repeats:YES];
    }
}
/**
 *  关闭定时器
 */
- (void)stopScroTimer{
    
    [_scroTimer invalidate];
    _scroTimer = nil;
}

/**
 *  定时器方法
 */
- (void)timerSel{
    
    CGPoint currentContentOffset = self.adScrollView.contentOffset;
    currentContentOffset.x += frame_width;
    
    //自己加滚动的动画,替代setContentOffset:<#(CGPoint)#> animated:<#(BOOL)#>
    
   [UIView animateWithDuration:0.5 animations:^{
      //滚动一个image
       self.adScrollView.contentOffset = currentContentOffset;
       
   } completion:^(BOOL finished) {
      //检查是否是最后一张和第一张
       [self checkOutFirstOrLast];
    
   }];
}

/**
 *  检查当前的坐标，更新坐标
 */
- (void)checkOutFirstOrLast{
   
    if (contentOffSet_x >= contentSize_w - frame_width) {
        //没有动画效果，所以看起来是无限的轮滑
        self.adScrollView.contentOffset = CGPointMake(frame_width, 0);
    }else if (contentOffSet_x <= 0){
        //同上
        self.adScrollView.contentOffset = CGPointMake(contentSize_w - 2*frame_width, 0);
    }
    
    //更新pagecontrol
    
    [self updatePageControl];

}
/**
 *  更新pagecontrol
 */
- (void)updatePageControl{
 
    NSInteger index = (contentOffSet_x - frame_width)/frame_width;
    self.pageControl.currentPage = index;
    
}

#pragma mark - scrollView的代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self stopScroTimer];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self startScroTimer];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self checkOutFirstOrLast];

}












@end
