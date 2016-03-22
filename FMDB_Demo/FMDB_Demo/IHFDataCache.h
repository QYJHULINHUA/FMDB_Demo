//
//  IHFDataCache.h
//  FMDB_Demo
//
//  Created by ihefe－hulinhua on 16/3/22.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHFDataCache : NSObject

#define  TableName @"dataCacheDemo" // 数据库表名

//>! 创
+ (BOOL)creatTable; //其实在load方法中实现会更好,调用一次即可



//>! 增
+ (BOOL)insetData:(NSString *)name age:(NSString *)age tel:(NSString *)tel;

//>! 删
+ (BOOL)removeAllRecord; // 清空表（不晴空字段，只清空表中数据）


//>! 改

//>! 查

//查询出表所有的列 (表字段)
+ (NSArray *)executeColumns;

//查询表中所有的数据
+ (NSMutableArray *)executeQueryAll;



@end
