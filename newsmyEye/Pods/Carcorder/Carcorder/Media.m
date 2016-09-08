//
//  Media.m
//  Carcorder
//
//  Created by YF on 16/3/2.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "Media.h"

@implementation Media

-(id)init
{
    self=[super init];
    if (self)
    {
        self.media=nil;
        self.dateAndTime=nil;
        self.mediaType=nil;
        self.mediaURL=nil;
        self.alasset = nil;
    }
    return  self;
}

@end
