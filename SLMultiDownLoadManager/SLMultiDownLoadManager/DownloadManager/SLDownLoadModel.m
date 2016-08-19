//
//  SLDownLoadModel.m
//  SLMultiDownLoadManager
//
//  Created by sunlei on 16/8/3.
//  Copyright © 2016年 sunlei. All rights reserved.
//

#import "SLDownLoadModel.h"
#import <objc/runtime.h>

@implementation SLDownLoadModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        Ivar var = ivar[i];
        const char *name = ivar_getName(var);
        //NSLog(@"%s==",name);
        NSString *nameStr = [NSString stringWithUTF8String:name];
        //利用kvc取值，用kvc的好处是当对应的属性的值不是OC类型的话，如bool,int，float 等等，返回值会自动转换成NSNumber等OC类型
        id value = [self valueForKey:nameStr];
        [aCoder encodeObject:value forKey:nameStr];
    }
    free(ivar);
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        unsigned int count = 0;
        //获取类中所有成员变量名
        Ivar *ivar = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            Ivar iva = ivar[i];
            const char *name = ivar_getName(iva);
            NSString *strName = [NSString stringWithUTF8String:name];
            //进行解档取值
            id value = [aDecoder decodeObjectForKey:strName];
            //利用KVC对属性赋值，可以将OC类型转换成对应的基础类型
            [self setValue:value forKey:strName];
        }
        free(ivar);
    }
    return self;
}

 
@end
