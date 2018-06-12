//  BaseVC.h
//  iosProject2
//  Created by bailing on 2018/6/9.
//  Copyright © 2018年 zhufeng. All rights reserved.

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController
///设置导航栏左边的按钮(图片)
-(void)setLeftButtonWithImage:(UIImage *)image;
///设置导航栏左边的按钮(文字)
-(void)setLeftButtonText:(NSString *)text;
///设置导航栏右边的按钮(图片)
-(void)setRightButtonWithImage:(UIImage *)image;
///设置导航栏右边的按钮(文字)
-(void)setRightButtonWithText:(NSString *)text;
///全部发返回按钮
-(void)backController;
///左边的返回事件
-(void)navigationBarWithLeftButtonEvent:(UIButton *)button;
///右边的返回事件
-(void)navigationBarWithRightButtonEvent:(UIButton *)button;
@end
