//  UIImage+Extension.m
//  iosProject2
//  Created by bailing on 2018/6/9.
//  Copyright © 2018年 zhufeng. All rights reserved.

#import "UIImageView+Extension.h"
#import <objc/runtime.h>

@implementation UIImageView (Extension)
//类别在加载的时候都会加载到这个方法
+(void)load
{
    //1.获取 UIImageView 的实例方法该方法位于本类,方法名为 setImage:
    Method originalMethod = class_getInstanceMethod([self class], @selector(setImage:));
    //2.获取 UIImageView 的实例方法该方法位于本类,方法名为 MD_setImage:
    Method swizzlingMethod = class_getInstanceMethod([self class], @selector(MD_SetImage:));
    //3.交换方法
    //注意点：setImage相当于调用了MD_SetImage
    method_exchangeImplementations(originalMethod, swizzlingMethod);
}

-(void)MD_SetImage:(UIImage *)image{
    NSLog(@"黑魔法执行了");
    //NSLog(@"%@",__func__);
    //1.根据 imageView 的大小,重新调整 image 的尺寸大小:
    //要搞一个严丝合缝的跟图片大小一样的 imageView:
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0) ;
    //绘制图像:
    [image drawInRect:self.bounds] ;
    //取得结果:
    //从当前图片上下文中获得图片:
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext() ;
    
    //关闭图片上下文:
    UIGraphicsEndImageContext() ;
    
    //交换方法之后系统就不会平行调用 setImage 方法了,我们要在这里去调用 setImage 方法:
    //而且!原有的 setImage 方法名也不叫 setImage 了,而是交换为了 MD_setImage 方法!!!切记!切记~
    [self MD_SetImage:result] ;
    //如果这里按照下面这么写!!!!那就是死循环!!!!切记!!!
    //    [self setImage:image] ;

}
@end
