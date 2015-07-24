//
//  YYView.m
//  06-10-手势解锁
//
//  Created by 袁野 on 15/6/10.
//  Copyright (c) 2015年 yuanye. All rights reserved.
//

#import "YYView.h"
#define YYLineColor [UIColor colorWithRed:0.0 green:170/255.0 blue:255/255.0 alpha:1.0]
@interface YYView()
//保存所有按钮
@property(nonatomic,strong)NSArray *buttons;
//保存所有碰过的按钮
@property(nonatomic,strong)NSMutableArray *selectedButton;
//线的颜色
@property(nonatomic,strong)UIColor *lineColor;
//记录用户最后触摸的点
@property(nonatomic,assign)CGPoint currentPoint;
@end
@implementation YYView
- (UIColor *)lineColor{
    if (_lineColor == nil) {
        _lineColor = YYLineColor;
    }
    return _lineColor;
}

- (NSMutableArray *)selectedButton{
    if (_selectedButton == nil) {
        _selectedButton = [NSMutableArray array];
    }
    return _selectedButton;
}
- (NSArray *)buttons
{
    if (_buttons ==nil) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.tag = i;
            button.userInteractionEnabled = NO;
            
//            设置按钮的背景图片
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateDisabled];
            [self addSubview:button];
            [arrayM addObject:button];
        }
        _buttons = arrayM;
    }
    return _buttons;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    设置每个按钮的frame
    CGFloat w = 74;
    CGFloat h = 74;
    int colnum = 3;
    CGFloat marginX = (self.frame.size.width - colnum * w ) / (colnum + 1);
    CGFloat marginY = (self.frame.size.height - colnum * h) / (colnum + 1);
//    计算每个按钮的X 和 Y
    for (int i = 0; i < self.buttons.count; i ++) {
        UIButton *button = self.buttons[i];
//        行和列
        int row = i / colnum;
        int col = i % colnum;
        CGFloat x = marginX + (w + marginX) * col;
        CGFloat y = marginY + (h + marginY) *row;
        button.frame = CGRectMake(x, y, w, h);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    获取当前触摸点
    UITouch *touch = touches.anyObject;
    CGPoint loc = [touch locationInView:touch.view];
//    循环判断当前触摸点在哪个按钮的范围之内,找到对一个按钮后,把select状态改为YEWS
    for (int i = 0 ; i<self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        if (CGRectContainsPoint(button.frame, loc)&&!button.selected) {
            button.selected = YES;
            [self.selectedButton addObject:button];
            break;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint loc = [touch locationInView:touch.view];
    self.currentPoint = loc;
        // 2. 循环判断当前触摸的点在哪个按钮的范围之内, 找到对一个的按钮之后, 把这个按钮的selected = YES
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        if (CGRectContainsPoint(button.frame, loc)&& (!button.selected)) {
            button.selected = YES;
            [self.selectedButton addObject:button];
            break;
        }
    }
//重绘
    [self setNeedsDisplay];
}
//手指抬起事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //    1.获取用户绘制密码
    NSMutableString *password = [NSMutableString string];
    for (UIButton *button in self.selectedButton) {
        [password appendFormat:@"%@",@(button.tag)];
    }
//    通过代理,把密码传递给控制器,在控制器中判断密码是否正确
    if ([self.delegate respondsToSelector:@selector(yyView:withPassword:)]) {
        if ([self.delegate yyView:self withPassword:password]) {
        
            [self clear];
        }else{
//        密码不正确
//            重绘红色效果,把selectedbutton中每个按钮的selected = NO ,enable = no;
            for (UIButton *button in self.selectedButton) {
                button.selected = NO;
                button.enabled = NO;
            }
//            设置线段颜色为红
            self.lineColor = [UIColor redColor];
//            重绘
            [self setNeedsDisplay];
//            禁用与用户交互
            self.userInteractionEnabled = NO;
//            等待0.5秒清空
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self clear];
                self.userInteractionEnabled = YES;
            });
        }
    }else{
        [self clear];
    }
}
- (void)clear
{
//先将所有selectedButton中的按钮的selected设置为NO
    for (UIButton *button in self.selectedButton) {
        button.selected = NO;
        button.enabled = YES;
    }
    self.lineColor = YYLineColor;
//    移除所有的按钮
    [self.selectedButton removeAllObjects];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.selectedButton.count == 0) return;
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
//   循环获取每个按钮的中心点,然后连线
    for (int i = 0; i < self.selectedButton.count; i++) {
        UIButton *button = self.selectedButton[i];
        if (i == 0) {
            [path moveToPoint:button.center];
        }else{
            [path addLineToPoint:button.center];
        }
    }
//    把最后手指的位置和最后一个按钮的中心点连起来
    [path addLineToPoint:self.currentPoint];
//    设置线条的颜色
    [self.lineColor set];
//    渲染
    [path stroke];
}


@end
