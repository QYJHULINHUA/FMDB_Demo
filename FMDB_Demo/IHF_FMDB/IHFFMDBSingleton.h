//
//  IHFFMDBSingleton.h
//  Demo_IphoneInfo
//
//  Created by ihefe－hulinhua on 16/3/22.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//



#define IHF_FMDB_SingletionH(FMDB_Name) \
+ (instancetype)shared##FMDB_Name;

#if __has_feature(objc_arc)

    #define IHF_FMDB_SingletionM(FMDB_Name) \
    static id _instace; \
\
    + (id)allocWithZone:(struct _NSZone *)zone \
    { \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
            _instace = [super allocWithZone:zone]; \
    }); \
        return _instace; \
    } \
\
    + (instancetype)shared##FMDB_Name \
    { \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
            _instace = [[self alloc] init]; \
        }); \
        return _instace; \
    } \
\
    - (id)copyWithZone:(NSZone *)zone \
    { \
        return _instace; \
    }

#else

    #define IHF_FMDB_SingletionM(FMDB_Name) \
    static id _instace; \
\
    + (id)allocWithZone:(struct _NSZone *)zone \
    { \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
            _instace = [super allocWithZone:zone]; \
        }); \
        return _instace; \
    } \
\
    + (instancetype)shared##FMDB_Name \
    { \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
            _instace = [[self alloc] init]; \
        }); \
        return _instace; \
    } \
\
    - (id)copyWithZone:(NSZone *)zone \
    { \
        return _instace; \
    } \
\
    - (oneway void)release { } \
    - (id)retain { return self; } \
    - (NSUInteger)retainCount { return 1;} \
    - (id)autorelease { return self;}

#endif