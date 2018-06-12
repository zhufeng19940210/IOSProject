//  UIButton+Addtation.h
//  iosProject2
//  Created by bailing on 2018/6/9.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import <UIKit/UIKit.h>
//回调的方法
typedef void (^ButtoClickCallBack)(UIButton *button);
@interface UIButton (Addtation)
//为button添加回调的方法
-(void)handleBlock:(ButtoClickCallBack)callblock;
@end
