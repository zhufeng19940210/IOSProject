//  PersonTool.m
//  iosProject2
//  Created by bailing on 2018/6/11.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "PersonTool.h"
#define DDUserInformationPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"user.data"]

@implementation PersonTool

//归档
+(void)saveWithoModel:(Person *)person
{
    [NSKeyedArchiver archiveRootObject:person toFile:DDUserInformationPath];
}
//解档
+(Person *)getPerson
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:DDUserInformationPath];
    
}
//删除归档
+(void)deletePerson
{
    NSFileManager *manater = [NSFileManager defaultManager];
    if ([manater isDeletableFileAtPath:DDUserInformationPath]) {
        [manater removeItemAtPath:DDUserInformationPath error:nil];
    }
}
@end
