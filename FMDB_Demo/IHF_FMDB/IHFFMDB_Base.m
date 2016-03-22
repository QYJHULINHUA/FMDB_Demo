//
//  IHFFMDB_Base.m
//  Demo_IphoneInfo
//
//  Created by ihefe－hulinhua on 16/3/22.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//

#import "IHFFMDB_Base.h"
#import "FMDB.h"

@interface IHFFMDB_FileManager : NSString

@end

@implementation IHFFMDB_FileManager

/**
 *  转为documents下的子文件夹
 */
+(NSString *)documentsSubFolder:(NSString *)subFolderPath
{
    
    NSString *documentFolder=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    return [IHFFMDB_FileManager makeSubFolderInSuperFolder:documentFolder subFloder:subFolderPath];
    
}

/**
 *  文件夹处理
 */
+(NSString *)makeSubFolderInSuperFolder:(NSString *)superFolder subFloder:(NSString *)subFloder{
    
    NSString *folder=[NSString stringWithFormat:@"%@/%@",superFolder,subFloder];
    
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:folder isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return folder;
}

@end

@interface IHFFMDB_Base ()

//>! FMDB 线程安全的数据队列
@property (nonatomic , strong) FMDatabaseQueue *queue;

@end
@implementation IHFFMDB_Base

IHF_FMDB_SingletionM(IHFFMDB_Base)

+(void)initialize
{
    IHFFMDB_Base *singletionFMDB = [IHFFMDB_Base sharedIHFFMDB_Base];
    NSDictionary *infoDic        = [[NSBundle mainBundle] infoDictionary];
    NSString     *key            = (NSString *)kCFBundleNameKey;
    NSString     *bundleName     = infoDic[key]; // 项目Bundle Name:英文(CFBundleName)
    
    //>! 本地数据库名
    NSString     *dbName         = [NSString stringWithFormat:@"%@%@",bundleName,@".sql"];
    // 数据库路径
    NSString     *dbPath         = [[IHFFMDB_FileManager documentsSubFolder:bundleName]
                                    stringByAppendingPathComponent:dbName];
    FMDatabaseQueue *queue       = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (queue == nil)            NSLog(@"code=1: 创建数据库失败，请检查！");
    if (NeedOutPutLog)           NSLog(@"IHFFMDB_dbPath:%@",dbPath);
    singletionFMDB.queue         = queue;
    
}


+(BOOL)FMDB_executeUpdate:(NSString *)sql;{
    
    __block BOOL updateRes = NO;
    
    IHFFMDB_Base *singletionFMDB=[IHFFMDB_Base sharedIHFFMDB_Base];
    
    [singletionFMDB.queue inDatabase:^(FMDatabase *db) {
        
        updateRes = [db executeUpdate:sql];
    }];
    
    return updateRes;
}

+(void)FMDB_executeQuery:(NSString *)sql queryResBlock:(void(^)(FMResultSet *set))queryResBlock
{
    IHFFMDB_Base *singletionFMDB = [IHFFMDB_Base sharedIHFFMDB_Base];
    [singletionFMDB.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:sql];
        if (queryResBlock != nil) queryResBlock(set);
    }];
}

+(NSArray *)FMDB_executeQueryColumnsInTable:(NSString *)table
{
    NSMutableArray *columnsM=[NSMutableArray array];
    
    NSString *sql=[NSString stringWithFormat:@"PRAGMA table_info (%@);",table];
    
    [self FMDB_executeQuery:sql queryResBlock:^(FMResultSet *set) {
        
        //循环取出数据
        while ([set next]) {
            NSString *column = [set stringForColumn:@"name"];
            [columnsM addObject:column];
        }
        
        if(columnsM.count==0) NSLog(@"code=2：您指定的表：%@,没有字段信息，可能是表尚未创建！",table);
    }];
    
    return [columnsM copy];
}

+(NSUInteger)FMDB_countTable:(NSString *)table
{
    NSString *alias=@"count";
    
    NSString *sql=[NSString stringWithFormat:@"SELECT COUNT(*) AS %@ FROM %@;",alias,table];
    
    __block NSUInteger count=0;
    
    [self FMDB_executeQuery:sql queryResBlock:^(FMResultSet *set) {
        
        while ([set next]) {
            
            count = [[set stringForColumn:alias] integerValue];
        }
    }];
    
    return count;
}

/**
 *  清空表（但不清除表结构）
 *
 *  @param table 表名
 *
 *  @return 操作结果
 */
+(BOOL)FMDB_truncateTable:(NSString *)table
{
    
    BOOL res = [self FMDB_executeUpdate:[NSString stringWithFormat:@"DELETE FROM '%@'", table]];
    [self FMDB_executeUpdate:[NSString stringWithFormat:@"DELETE FROM sqlite_sequence WHERE name='%@';", table]];
    return res;
}

@end









