//
//  Person.h
//  iosProject2
//
//  Created by bailing on 2018/6/9.
//  Copyright © 2018年 zhufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>

@property (nonatomic,strong)NSString *pics;

@property (nonatomic,copy) NSString *classname;

@property (nonatomic,assign)int score;

@property (nonatomic,strong) NSNumber *number;

-(void)demo;

@end
