//
//  ADCollectionView.m
//  ADScrollView
//
//  Created by 叶杨杨 on 16/4/17.
//  Copyright © 2016年 叶杨杨. All rights reserved.
//

#import "ADCollectionView.h"
#import "CustomCollectionViewCell.h"

static NSString * const cellIdentifier = @"customIdentifier";

@interface ADCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) CGFloat timeInterval;
@property (nonatomic,assign) NSInteger currentItem;
@property (nonatomic,strong) NSTimer *timer;
//@property (nonatomic,copy) clickCollectionCellCallBack callBack;

@end



@implementation ADCollectionView

- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSArray*)dataArray
             didselectedBlock:(clickCollectionCellCallBack)callBack
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = [self getFinalDataArr:dataArray];
        self.currentItem = 1;
        self.callBack = callBack;
        
        //加载collectionView
        [self loadCollectionView];
        //加载pagecontrol
        [self loadPageControl];
        
        if (self.dataArray.count > 1) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentItem inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSArray*)dataArray
                 timeInterval:(CGFloat)timeINterval
             didselectedBlock:(clickCollectionCellCallBack)callBack
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = [self getFinalDataArr:dataArray];
        self.currentItem = 1;
        self.timeInterval = timeINterval;
        self.callBack = callBack;
        
        //加载collectionView
        [self loadCollectionView];
        //加载pagecontrol
        [self loadPageControl];
        //加载计时器
        [self loadTimer];
        
        if (self.dataArray.count > 1) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentItem inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
    
    return self;
}
/**
 *  对照片数组进行加工
 *
 *  @param param 传入的数组
 *
 *  @return 返回轮播需要的数组
 */
- (NSArray *)getFinalDataArr:(NSArray *)param {
    
    NSMutableArray *resultArr = [[NSMutableArray alloc]initWithCapacity:param.count];
    
    [resultArr addObject:param.lastObject];
    
    for (id object in param) {
        
        [resultArr addObject:object];
    }
    
    [resultArr addObject:param.firstObject];
    
    return resultArr;
}
/**
 *  加载collectionView
 */
- (void)loadCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    flowLayout.sectionInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
   // self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    [self addSubview:self.collectionView];

}
/**
 *  加载pagecontrol
 */
- (void)loadPageControl{
    
    CGRect rect = CGRectMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame) - 20.f, 0.f, 20.f);
    self.pageControl = [[UIPageControl alloc]initWithFrame:rect];
    self.pageControl.numberOfPages = self.dataArray.count - 2;
    self.pageControl.currentPage = 0;
    self.pageControl.defersCurrentPageDisplay = YES;
    
    [self addSubview:self.pageControl];
    
}
/**
 *  加载计时器
 */
- (void)loadTimer{
    
    if (!self.timer) {
        
        self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(nextADCell) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    }
    
}
/**
 *  计时器的调用方法
 */
- (void)nextADCell{

    if (self.currentItem == self.dataArray.count - 2) {
        
        NSInteger toItem = 0;
        NSIndexPath *inexPath = [NSIndexPath indexPathForItem:toItem inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:inexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        self.currentItem = toItem;

    }
    
    self.currentItem++;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentItem inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    self.pageControl.currentPage = self.currentItem - 1;
    
}
#pragma mark -collectionView的代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count == 1?1:self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSLog(@"相片数组 %@",self.dataArray);
    cell.image =[UIImage imageNamed:self.dataArray[indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.callBack) {
        
        self.callBack(indexPath.item - 1);
        
    }

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    if (self.timer) {
        
        [self.timer invalidate];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self refreshCoordinate];
    
    if (self.timer) {
        
        [self loadTimer];
    }
}
/**
 *  刷新坐标
 */
- (void)refreshCoordinate{
    
    //获取当前cell的index
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    self.currentItem = indexPath.item;
    NSInteger toItem = 0;
    
    if (self.currentItem == 0) {
        
        toItem = self.dataArray.count - 2;
        
        NSIndexPath *index = [NSIndexPath indexPathForItem:toItem inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        self.currentItem = toItem;
    }
    
    if (self.currentItem == self.dataArray.count - 1) {
        
        toItem = 1;
        NSIndexPath *index = [NSIndexPath indexPathForItem:toItem inSection:0];
        [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        self.currentItem = toItem;
    }
    
    self.pageControl.currentPage = self.currentItem -1;
    
}





@end
