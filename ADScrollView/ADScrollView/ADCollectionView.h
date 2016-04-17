//
//  ADCollectionView.h
//  ADScrollView
//
//  Created by 叶杨杨 on 16/4/17.
//  Copyright © 2016年 叶杨杨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^clickCollectionCellCallBack)(NSInteger index);

@interface ADCollectionView : UIView

@property (nonatomic,copy) clickCollectionCellCallBack callBack;

- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSArray*)dataArray
             didselectedBlock:(clickCollectionCellCallBack)callBack;

- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSArray*)dataArray
                 timeInterval:(CGFloat)timeINterval
             didselectedBlock:(clickCollectionCellCallBack)callBack;





@end
