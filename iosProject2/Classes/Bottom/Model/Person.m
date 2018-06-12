//  Person.m
//  iosProject2
//  Created by bailing on 2018/6/9.
//  Copyright © 2018年 zhufeng. All rights reserved.

#import "Person.h"
#import <objc/runtime.h>
@interface Person ()
{
    int _age;
    double _heigt;
    NSString *_name;
}
@end
@implementation Person

-(void)demo
{
    NSLog(@"%s",__func__);
}

-(void)test{
    NSLog(@"%s",__func__);
}
//归档
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //取出全部的数据
    unsigned int  count = 0;
    //遍历全部的字段
    objc_property_t *propertes = class_copyPropertyList([self class], &count);
    for (int i = 0 ; i < count; i++) {
        //获取当前遍历的属性的名称
        const char *propertyName = property_getName(propertes[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        //利用kvc取出对应的值
        id value = [self valueForKey:name];
        //归档
        [aCoder encodeObject:value forKey:name];
    }
}
//解档
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned int count =0;
        //1.取出所有的属性
        objc_property_t *propertes = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            //获取当前遍历的属性的名称
            const char *propertyName = property_getName(propertes[i]);
            //转换下格式
            NSString *name = [NSString stringWithUTF8String:propertyName];
            //取出数据
            id value = [aDecoder decodeObjectForKey:name];
            
            [self setValue:value forKey:name];
            
        }
    }
    return self;
}


@end
