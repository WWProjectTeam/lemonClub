//
//  AccountInfo.m
//  Carcorder
//
//  Created by YF on 16/1/4.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "AccountInfo.h"

//定义全局静态变量
//static AccountInfo *info=nil;

@implementation AccountInfo

/*设置单例类*/
/*
//重写alloc方法封堵创建方法(调用alloc方法时,默认会走allocWithZone这个方法,所以只需封堵allocWithZone方法即可)
+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (!info)
        {
            //如果没有实例让父类去创建一个
            info=[super allocWithZone:zone];
            
            return info;
        }
        
        return nil;
    }
}

//定义一个类方法进行访问(便利构造)
+(AccountInfo *)shareInfo
{
    @synchronized(self)
    {
        if (!info)
        {
            //如果实例不存在进行创建
            info=[[AccountInfo alloc] init];
        }
        
        return info;
    }
}

//封堵深复制(copy和mutablecopy都可以实现深复制,但他们最终都需要调用copyWithZone方法所以直接封堵它)
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}
*/

@end
