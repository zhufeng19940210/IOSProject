//  PersonTool.h
//  iosProject2
//  Created by bailing on 2018/6/11.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import <Foundation/Foundation.h>
#import "Person.h"


///归解档的工具
@interface PersonTool : NSObject
//归档
+(void)saveWithoModel:(Person *)person;
//解档
+(Person *)getPerson;
//删除归档
+(void)deletePerson;

@end
