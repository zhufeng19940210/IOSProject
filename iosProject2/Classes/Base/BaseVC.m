//  BaseVC.m
//  iosProject2
//  Created by bailing on 2018/6/9.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //标题
        NSDictionary *attri = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:17]
                                };
        //设置导航栏颜色
        [self.navigationController.navigationBar setTitleTextAttributes:attri];
        //设置导航栏覆盖
        [self.navigationController.navigationBar setTranslucent:NO];
        //shadowline
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
        //设置导航栏的样式
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        //更新状态栏
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    [self setBackwardButton];
}

///设置返回的按钮
-(void)setBackwardButton{
    NSArray *viewcontrollers = [self.navigationController viewControllers];
    if (viewcontrollers.count > 1) {
        UIImage *leftimage = [UIImage imageNamed:@"left"];
        UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
        [leftButton setImage:leftimage forState:UIControlStateNormal];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -5, .0, 5.0);
        [leftButton addTarget:self action:@selector(navigationBarWithLeftButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    }
}
///设置导航栏左边的按钮(图片)
-(void)setLeftButtonWithImage:(UIImage *)image{
    if (image) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
        [button addTarget:self action:@selector(navigationBarWithLeftButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = item;
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc]init]];
    }
}
///设置导航栏左边的按钮(文字)
-(void)setLeftButtonText:(NSString *)text
{
    if (text) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:text forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(navigationBarWithLeftButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc]init]];
    }
}
///设置导航栏右边的按钮(图片)
-(void)setRightButtonWithImage:(UIImage *)image{
    if (image) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 4.0, 0.0, -4.0);
        [btn addTarget:self action:@selector(navigationBarWithRightButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = item;
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc]init]];
    }
}
///设置导航栏右边的按钮(文字)
-(void)setRightButtonWithText:(NSString *)text{
    if (text) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:text forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
        [btn addTarget:self action:@selector(navigationBarWithRightButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = item;
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc]init]];
    }
}
///全部发返回按钮
-(void)backController{
    NSArray *viewcontrollers = [self.navigationController viewControllers];
    // 根据viewControllers的个数来判断此控制器是被present的还是被push的
    if ( 1 <= viewcontrollers.count && 0 < [viewcontrollers indexOfObject:self]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
///左边的返回事件
-(void)navigationBarWithLeftButtonEvent:(UIButton *)button{
    [self backController];
}
///右边的返回事件
-(void)navigationBarWithRightButtonEvent:(UIButton *)button{
    
}
@end
