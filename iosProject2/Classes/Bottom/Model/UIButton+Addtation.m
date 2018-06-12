//  UIButton+Addtation.m
//  iosProject2
//  Created by bailing on 2018/6/9.
//  Copyright © 2018年 zhufeng. All rights reserved.

#import "UIButton+Addtation.h"
#import <objc/runtime.h>
// 声明一个静态的索引key，用于获取被关联对象的值
static char *buttonClickKey;
@implementation UIButton (Addtation)
-(void)handleBlock:(ButtoClickCallBack)callblock
{
    // 将button的实例与回调的block通过索引key进行关联：
    objc_setAssociatedObject(self, &buttonClickKey, callblock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //设置button的响应事件了
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)buttonClick:(UIButton *)button
{
    ButtoClickCallBack callback = objc_getAssociatedObject(self, &buttonClickKey);
    if (callback) {
        callback(self);
    }
}
@end
