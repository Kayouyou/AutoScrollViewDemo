//
//  ViewController.m
//  ADScrollView
//
//  Created by 叶杨杨 on 16/4/17.
//  Copyright © 2016年 叶杨杨. All rights reserved.
//

#import "ViewController.h"
#import "ADScrollViewComponent.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray * images = [NSMutableArray array];
    
    for (NSInteger i = 0; i<8; i++)
    {
        [images addObject:[NSString stringWithFormat:@"%02ld.jpg",i+1]];
    }

    ADScrollViewComponent *adScro = [ADScrollViewComponent adScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) imageItems:images  andImageClickCallBack:^(NSInteger index) {
       
        NSLog(@"=== %ld ===",index);
    
    }];
    
    [self.view addSubview:adScro];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
