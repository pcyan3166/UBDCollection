//
//  UBDDatabaseService.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FMDatabase;
@class FMDatabaseQueue;

@interface UBDDatabaseService : NSObject

/// 数据库队列，为多线程操作数据库提供线程安全保障
@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

/// 单例对象
+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
