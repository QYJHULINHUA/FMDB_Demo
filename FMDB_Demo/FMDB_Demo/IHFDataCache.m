//
//  IHFDataCache.m
//  FMDB_Demo
//
//  Created by ihefe－hulinhua on 16/3/22.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import "IHFDataCache.h"
#import "IHFFMDB_Base.h"

@implementation IHFDataCache


+ (BOOL)creatTable
{
    NSString *createSQLStr = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoIncrement,name text,age text,tel text)",TableName];
    return [IHFFMDB_Base FMDB_executeUpdate:createSQLStr];
}


+ (BOOL)insetData:(NSString *)name age:(NSString *)age tel:(NSString *)tel
{
    NSString *insertStr = [NSString stringWithFormat:@"insert into %@(name,age,tel) values('%@','%@','%@')",TableName,name,age,tel];
    return [IHFFMDB_Base FMDB_executeUpdate:insertStr];
}
+ (NSArray *)executeColumns
{
    return [IHFFMDB_Base FMDB_executeQueryColumnsInTable:TableName];
}

+ (NSMutableArray *)executeQueryAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@;",TableName];
    return [self queryDataList:sql];
}

+ (NSMutableArray *)queryDataList:(NSString *)sql
{
    NSMutableArray *arr = [NSMutableArray array];
    [IHFFMDB_Base FMDB_executeQuery:sql queryResBlock:^(FMResultSet *set) {
        while ([set next]) {
            NSDictionary *dic = @{ @"id":[set stringForColumn:@"id"]
                                   ,@"name":[set stringForColumn:@"name"]
                                   ,@"age":[set stringForColumn:@"age"]
                                   ,@"tel":[set stringForColumn:@"tel"]};
            
            [arr addObject:dic];
        }
        
    }];
    return arr;
}

// 清除所有记录
+ (BOOL)removeAllRecord
{
    return [IHFFMDB_Base FMDB_truncateTable:TableName];
}


@end
