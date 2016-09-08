//
//  Message.m
//  Carcorder
//
//  Created by EthanZhang on 16/2/19.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "Message.h"

@implementation Message
- (id)init
{
    self=[super init];
    if (self) {
        self.id=0;
        self.content=@"";
        self.device=@"";
        self.type=0;
        self.point_or_text=0;
        self.time=@"";
    }
    return self;
}
@end
