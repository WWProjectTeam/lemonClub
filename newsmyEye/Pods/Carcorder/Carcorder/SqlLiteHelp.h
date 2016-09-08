//
//  SqlLiteHelp.h
//  Carcorder
//
//  Created by EthanZhang on 16/2/19.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Message.h"

@interface SqlLiteHelp : NSObject
{
    sqlite3 *db;
}
-(void) createMessageTable;
-(void) addMessage:(Message*)mes;
-(void)deleteMessage;
-(NSMutableArray*)getMessages;

@end
