//
//  ViewController.m
//  06-10-手势解锁
//
//  Created by 袁野 on 15/6/10.
//  Copyright (c) 2015年 yuanye. All rights reserved.
//

#import "ViewController.h"
#import "YYView.h"
@interface ViewController ()<YYViewDelegate>
@property (weak, nonatomic) IBOutlet YYView *unclock;


@end

@implementation ViewController
- (BOOL)yyView:(YYView *)yyView withPassword:(NSString *)password{
    if ([password isEqualToString:@"012"]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.unclock.delegate = self;
//    设置背景图片
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeButtomBG"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
