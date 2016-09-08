//
//  SqlLiteHelp.m
//  Carcorder
//
//  Created by EthanZhang on 16/2/19.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "SqlLiteHelp.h"
#define DBNAME @"carcorder.sqlite"

@implementation SqlLiteHelp

-(void)openDataBase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK)
    {
        NSLog(@"数据库打开失败");
        sqlite3_close(db);
    }

}
-(void)createMessageTable
{
    [self openDataBase];
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS message (ID INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT, device text, type INTEGER,point_or_text INTEGER,messagetime text)";
    [self execSql:sqlCreateTable];
    sqlite3_close(db);
}

-(void)addMessage:(Message *)mes
{
    [self openDataBase];
    NSString *sql1 = [NSString stringWithFormat:
                      @"INSERT INTO message(content,device,type,point_or_text,messagetime) VALUES ('%@', '%@', '%ld', '%ld', '%@')",
                      mes.content,mes.device,(long)mes.type,(long)mes.point_or_text,mes.time];
    [self execSql:sql1];
    sqlite3_close(db);
}

-(void)deleteMessage
{
    [self openDataBase];
    
    NSString *sql2=@"delete from message";
    
    [self execSql:sql2];
    
    sqlite3_close(db);
}

-(NSMutableArray*)getMessages
{
    [self openDataBase];
    NSMutableArray *messages=[NSMutableArray new];
    NSString *device=[USER valueForKey:@"device"];
    NSString *sqlQuery =[NSString stringWithFormat:@"SELECT * FROM message where device='%@'",device];
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Message *message=[[Message alloc] init];
            char *content = (char*)sqlite3_column_text(statement, 1);
            message.content = [[NSString alloc]initWithUTF8String:content];
            
            char *device = (char*)sqlite3_column_text(statement, 2);
            message.device = [[NSString alloc]initWithUTF8String:device];
            
            message.type= sqlite3_column_int(statement, 3);
            message.point_or_text= sqlite3_column_int(statement, 4);
            
            char *time = (char*)sqlite3_column_text(statement, 5);
            message.time = [[NSString alloc]initWithUTF8String:time];
            [messages addObject:message];
        }
    }
    sqlite3_close(db);
    return messages;
}
-(void)execSql:(NSString *)sql
{
    char *err=nil;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        NSLog(@"数据库操作数据失败!");
        sqlite3_close(db);
    }
}
@end
