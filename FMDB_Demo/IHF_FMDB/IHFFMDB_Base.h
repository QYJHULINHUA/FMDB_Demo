//
//  IHFFMDB_Base.h
//  Demo_IphoneInfo
//
//  Created by ihefe－hulinhua on 16/3/22.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IHFFMDBSingleton.h"
#import "FMResultSet.h"

@interface IHFFMDB_Base : NSObject

#define NeedOutPutLog 1 // 是否输出log

//>! 定义宏单例
IHF_FMDB_SingletionH(IHFFMDB_Base)

/**
 *  执行一个更新语句
 *
 *  @param sql 更新语句的sql
 *
 *  @return 更新语句的执行结果
 */
+(BOOL)FMDB_executeUpdate:(NSString *)sql;

/**
 *  执行一个查询语句
 *
 *  @param sql              查询语句sql
 *  @param queryResBlock    查询语句的执行结果
 */
+(void)FMDB_executeQuery:(NSString *)sql queryResBlock:(void(^)(FMResultSet *set))queryResBlock;

/**
 *  查询出指定表的列
 *
 *  @param table table
 *
 *  @return 查询出指定表的列的执行结果
 */
+(NSArray *)FMDB_executeQueryColumnsInTable:(NSString *)table;

/**
 *  表记录数计算
 *
 *  @param table 表
 *
 *  @return 记录数
 */
+(NSUInteger)FMDB_countTable:(NSString *)table;

/**
 *  清空表（但不清除表结构）
 *
 *  @param table 表名
 *
 *  @return 操作结果
 */
+(BOOL)FMDB_truncateTable:(NSString *)table;


@end
