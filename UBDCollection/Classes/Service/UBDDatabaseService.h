//
//  UBDDatabaseService.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FMDatabase;

@interface UBDDatabaseService : NSObject

/// sqlite database 句柄
@property (nonatomic, assign) FMDatabase *database;

/// 单例对象
+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
