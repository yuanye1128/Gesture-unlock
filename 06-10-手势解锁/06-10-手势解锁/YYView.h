//
//  YYView.h
//  06-10-手势解锁
//
//  Created by 袁野 on 15/6/10.
//  Copyright (c) 2015年 yuanye. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYView;
@protocol YYViewDelegate <NSObject>
- (BOOL)yyView:(YYView *)yyView withPassword:(NSString *)password;
@end
@interface YYView : UIView
@property(nonatomic,weak)id <YYViewDelegate> delegate;
@end
