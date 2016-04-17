//
//  CustomCollectionViewCell.m
//  ADScrollView
//
//  Created by 叶杨杨 on 16/4/17.
//  Copyright © 2016年 叶杨杨. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@interface CustomCollectionViewCell()
@property (nonatomic, strong) UIImageView *imageVIew;


@end



@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame: frame];
    if (self) {
        
        [self loadImageView];
    }
    
    return self;
}
/**
 *  设置collectionView的contenView为iamgeView
 */
- (void)loadImageView{

    if (!self.imageVIew) {
        
        self.imageVIew = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imageVIew.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.imageVIew];
    }
}

- (void)setImage:(UIImage *)image{
    
    _image = image;
    self.imageVIew.image = _image;
}













@end
