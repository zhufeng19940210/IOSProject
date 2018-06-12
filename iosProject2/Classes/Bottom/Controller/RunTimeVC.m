//  RunTimeViewController.m
//  iosProject2
//  Created by bailing on 2018/6/9.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "RunTimeVC.h"
#import <objc/runtime.h>
#import "UIButton+Addtation.h"          ///关联对象
#import "UIImageView+Extension.h"       ///黑魔法
#import "Person.h"                      ///归档解档
#import "PersonTool.h"                  ///归档解档的工具
@interface RunTimeVC ()
{
    
}
@property (nonatomic,strong)UIButton *testBtn; //测试的button
@property (weak, nonatomic) IBOutlet UIButton *assobject_btn;
@property (weak, nonatomic) IBOutlet UIImageView *iconimageView;
@end
@implementation RunTimeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运行RunTime的知识运用";
    //1.runtime的概念
    [self LearnWithRuntime];
    //关联对象的方法
    [self.assobject_btn handleBlock:^(UIButton *button) {
        NSLog(@"调用了runtime的关联对象的方法");
    }];
    //黑魔法的方法
    //[self.iconimageView setImage:[UIImage imageNamed:@"1"]];
}
#pragma mark --- runtime的概念
-(void)LearnWithRuntime
{
    NSLog(@"runtime的概念");
    /*
     * 1.runtime的概念:
        runtime是object-c的幕后工作者,这门语言第动态性,运行时在进行的时候,在正在调用的时候才会更加函数名找到对应的函数
        runtime是一套比较底层的纯c语言的api,属于一个语言库，他包含了很多的c语言的api，
        我们平时写的oc代码底层的时候最后都转成了runtime的c语言的代码,消息机制
     */
    /*
      2.类在oc中都是object_class的结构体指针
        object_class的结构体如下:
        Class _Nonnull isa  OBJC_ISA_AVAILABILITY;               //指向元类的指针isa
        Class _Nullable super_class                              OBJC2_UNAVAILABLE; 父类
        const char * _Nonnull name                               OBJC2_UNAVAILABLE; 类名
        long version                                             OBJC2_UNAVAILABLE; 版本信息
        long info                                                OBJC2_UNAVAILABLE; 类信息
        long instance_size                                       OBJC2_UNAVAILABLE; 实例变量的大小
        struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE; 该类成员变量的链表
        struct objc_method_list * _Nullable * _Nullable methodLists                 该类的方法的链表   OBJC2_UNAVAILABLE;
        struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE; 方法缓存
        struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE; 协议链表
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 关联对象
- (IBAction)actionContentBtn:(UIButton *)sender
{
    
    /* 1.关联对象的方法
     1.设置关联
    ojc_setAssociatedObject
     //2.获取关联
    objc_getAssociatedObject
     //3.y移除关联
    objc_removeAssociatedObjects
    2.设置关联的方法
     void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
         1.第一个参数 object :关联的源对象
         2.第二个参数 key :获取被关联的索引key
         3.第三个参数 value: 被关联者
         4.四个参数   policy :缓存策略 一般使用 OBJC_ASSOCIATION_RETAIN_NONATOMIC
    3.获取关联的方法
    void objc_getAssociateObjec(id object, const void *key);
        1.第一个参数：object : 关联的源对象
        2.第二个参数: key    :获取被关联的索引key
     };
     4.移除关联的方法
     void removeAssocaitedObject(id object)
        1.第一个参数: 表示关联的源对象
     5.runtime的实践的使用
     下面以UIButton为例，使用关联对象完成一个功能函数：为UIButton增加一个Category，定义一个方法，使用block去实现button的点击回调。
     UIButton+Addition.h
    */
    
}
#pragma mark 消息转发
- (IBAction)actionChanegMsgBtn:(UIButton *)sender
{
    //执行找不到的方法然后执行的消息转发的方法,如果没有知道这放了
    [self performSelectorOnMainThread:@selector(dosomeMethod:) withObject:nil waitUntilDone:YES];
}
/*
 self回去找自己是否有想执行的方法
 self找不到someMethod的时候，会走下面的方法
 找到了anotherMethod，则不会走下面的方法
 */
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *selString = NSStringFromSelector(sel);
    if ([selString isEqualToString:@"someMethod"]) {
        // 在找不到someMethod的时候，给当前类添加一个someMethod方法
        void(^block)() = ^(){
            NSLog(@"执行了someMethod方法");
        };
        class_addMethod(self, sel, imp_implementationWithBlock(block), "");
        return YES;
    }else{
        NSLog(@"找到了anotherMethod");    // 不会执行
        return [super resolveInstanceMethod:sel];
    }
}

#pragma mark  黑魔法
- (IBAction)actionSwizzingBtn:(UIButton *)sender
{
    [self.iconimageView setImage:[UIImage imageNamed:@"1"]];
}
#pragma mark  归解档
- (IBAction)actionJiedangBtn:(UIButton *)sender
{   //1.获取方法
    //[self getProperty];
    [self archiverMethod];
}
#pragma mark -- 解档
- (IBAction)actionjiedangBtn:(UIButton *)sender
{
    [self unarchiverMethod];
}
#pragma mark  获取方法
-(void)getMethod{
    unsigned int count =0;
    Method *methods = class_copyMethodList([Person class], &count);
    for (int i = 0; i< count; i++) {
        //1.获取遍历得到的方法名称
        SEL m = class_getName((__bridge Class _Nullable)(methods[i]));
        //2.将方法名转变成字符串
        NSString *methodName = NSStringFromSelector(m);
        //3.输出
        NSLog(@"方法名称:%@",methodName);
    }
}
#pragma mark  获取成员变量
-(void)getIvar{
    unsigned int count = 0;
    //得到成员变量
    Ivar *vars = class_copyIvarList([Person class], &count);
    //开始去遍历
    for (int i = 0; i<count; i++) {
        //1.得到成员变量的名称
        const char *varName = ivar_getName(vars[i]);
        //2.转换成字符串的东西
        NSString *name = [NSString stringWithUTF8String:varName];
        //3.输出结果
        NSLog(@"成员变量的:%@",name);
    }
}

#pragma mark 获取属性列表
-(void)getProperty
{
    unsigned int count = 0 ;
    //获取属性列表
    objc_property_t *propeties = class_copyPropertyList([Person class], &count);
    //开始去遍历东西了
    for (int i = 0; i<count; i++) {
        //1.遍历得到
        const char *propetyname = property_getName(propeties[i]);
        //2.转换成字符串输出
        NSString *name = [NSString stringWithUTF8String:propetyname];
        //3.输出名称
        NSLog(@"属性列表:%@",name);
    }
}
#pragma mark -- 归档
-(void)archiverMethod
{
    Person *person = [[Person alloc]init];
    person.pics = @"fengfeng";
    person.score = 98;
    person.classname = @"test";
    person.number = @"100";
    [PersonTool saveWithoModel:person];
}
#pragma mark -- 解档
-(void)unarchiverMethod
{
    Person *peron = [PersonTool getPerson];
    NSLog(@"person.pics:%@",peron.pics);
    NSLog(@"person.score:%d",peron.score);
    NSLog(@"person.classname:%@",peron.classname);
    NSLog(@"person.number:%@",peron.number);
}
@end
