//
//  UBDRequestItemService.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/3.
//

#import "UBDRequestItemService.h"
#import "UBDEventItemService.h"
#import "UBDRequestItem.h"
#import "UBDEventsPackage.h"
#import <BasicTools/BasicTools+AppInfo.h>
#import <BasicTools/BasicTools+DeviceInfo.h>
#import "UBDDatabaseService.h"
#import <fmdb/FMDB.h>
#import <BasicTools/PublicValueSaverService.h>

#define UBD_REQUEST_PRE_TIMESTAMP_KEY   @"ubdRequestPreTimestamp"
#define UBD_REQUEST_CUR_TIMESTAMP_KEY   @"ubdRequestCurTimestamp"

@implementation UBDRequestItemService

+ (instancetype)shareInstance {
    static UBDRequestItemService *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[UBDRequestItemService alloc] init];
    });
    
    return sInstance;
}

+ (void)createARequestToSendEventsWithCount:(NSUInteger)count
                             andResultBlock:(CreateRequestItemResultBlock)resultBlock {
    if (count > 0) {
        [UBDEventItemService getPreviousPageEventsWithPartitionEventId:-1 descOrder:NO andPageCount:count andResultBlock:^(NSArray<UBDEventItem *> * _Nonnull items, BOOL hasMore) {
            if (items.count > 0) {
                [UBDRequestItemService createARequestWithEvents:items
                                                 andResultBlock:^(UBDRequestItem * _Nullable item) {
                    resultBlock(item);
                }];
            } else {
                resultBlock(nil);
            }
        }];
    } else {
        resultBlock(nil);
    }
}

+ (void)createARequestWithEvents:(NSArray<UBDEventItem *> * _Nonnull)items
                  andResultBlock:(CreateRequestItemResultBlock)resultBlock {
    if (items.count > 0) {
        UBDEventsPackage *package = [UBDRequestItemService createAPackageWithEvents:items];
        UBDRequestItem *requestItem = [[UBDRequestItem alloc] init];
        requestItem.eventPackage = package;
        requestItem.reqTs = [[NSDate date] timeIntervalSince1970] * 1000;
        requestItem.resTs = 0;
        requestItem.success = NO;
        requestItem.failReason = @"";
        
        [UBDRequestItemService addRequest:requestItem withResult:^(UBDRequestItem * _Nullable item) {
            if (item != nil) {
                package.rId = item.rId;
                [UBDRequestItemService addPackageInfoItem:package];
                [UBDEventItemService updateSendStatus:eUnknown toStatus:eSending forEvents:items];
            }
            
            resultBlock(item);
        }];
    }
}

+ (UBDEventsPackage *)createAPackageWithEvents:(NSArray<UBDEventItem *> * _Nonnull)items {
    if (items.count > 0) {
        UBDEventsPackage *package = [[UBDEventsPackage alloc] init];
        package.appId = [BasicTools appId];
        package.appVersion = [BasicTools appVersion];
        package.osType = [BasicTools osType];
        package.osVersion = [BasicTools osVersion];
        package.deviceBrand = [BasicTools deviceBrand];
        package.deviceType = [BasicTools deviceType];
        package.networkType = [BasicTools networkType];
        package.deviceId = [BasicTools deviceId];
        if ([UBDRequestItemService shareInstance].userId.length > 0) {
            package.userId = [UBDRequestItemService shareInstance].userId;
        }
        if ([UBDRequestItemService shareInstance].tags.count > 0) {
            package.tags = [UBDRequestItemService shareInstance].tags;
        }
        
        package.preTs = 0;
        NSNumber *preTsNum = [[PublicValueSaverService shareInstance] getNumberValueForKey:UBD_REQUEST_PRE_TIMESTAMP_KEY];
        if (preTsNum != nil && [preTsNum isKindOfClass:[NSNumber class]]) {
            package.preTs = [preTsNum integerValue];
        }
        
        package.curTs = [[NSDate date] timeIntervalSince1970] * 1000;
        package.events = items;
    }
    
    return nil;
}

+ (void)addRequest:(UBDRequestItem *)item withResult:(AddRequestItemResultBlock)result {
    NSString *sql = [NSString stringWithFormat:@"insert into t_requests \
                     (reqTs, resTs, success, failReason) values (%ld, %ld, %d, %@)",
                     item.reqTs, item.resTs, item.success, item.failReason];
    [[UBDDatabaseService shareInstance].databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:sql];
        
        FMResultSet *set = [db executeQuery:@"select rId from t_events where rowid = last_insert_rowid()"];
        if ([set next]) {
            item.rId = [set intForColumnIndex:0];
            if (result) {
                result(item);
            }
        } else {
            if (result) {
                result(item);
            }
        }
    }];
}

+ (void)addPackageInfoItem:(UBDEventsPackage *)item {
    NSString *tags = nil;
    if (item.tags.count > 0) {
        tags = [item.tags componentsJoinedByString:@","];
    }
    
    NSString *sql = [NSString stringWithFormat:@"insert into t_events_packages \
                     (appVersion, osVersion, networkType, deviceId, userId, tags, preTs, curTs, rId) values \
                     (%@, %@, %@, %@, %@, %@, %ld, %ld, %ld)",
                     item.appVersion, item.osVersion, item.networkType, item.deviceId, item.userId ? item.userId : @"''",
                     tags ? tags : @"''", item.preTs, item.curTs, item.rId];
    [[UBDDatabaseService shareInstance].databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:sql];
    }];
}

+ (void)clearRequests {
    [[UBDDatabaseService shareInstance].databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        FMResultSet *set = [db executeQuery:@"select rId from t_requests"];
        while ([set next]) {
            NSInteger rId = [set intForColumnIndex:0];
            if (rId > 0) {
                // 删除相关联的events信息
                [UBDEventItemService removeEventsWithRequestId:rId];
            }
        }
        
        // 删除所有请求packge信息
        [db executeUpdate:@"delete from t_events_packages"];
        
        // 删除所有数据
        [db executeUpdate:@"delete from t_requests"];
    }];
}

+ (void)getPreviousPageRequestsWithPartitionRequestId:(NSInteger)rId
                                            descOrder:(BOOL)isDesc
                                         andPageCount:(NSUInteger)count
                                       andResultBlock:(GetRequestsDataResultBlock)resultBlock {
    NSString *sql = [NSString stringWithFormat:@"select * from t_requests order by rId %@ limit %lu",
                     isDesc ? @"desc" : @"asc", count + 1];
    if (rId > 0) {
        if (isDesc) {
            sql = [NSString stringWithFormat:@"select * from t_requests where rId > %ld order by rId %@ limit %lu",
                   rId, isDesc ? @"desc" : @"asc", count + 1];
        } else {
            sql = [NSString stringWithFormat:@"select * from t_requests where rId < %ld order by rId %@ limit %lu",
                   rId, isDesc ? @"desc" : @"asc", count + 1];
        }
    }
    
    [UBDRequestItemService getEventsDataWithSql:sql withCount:count andResultBlock:resultBlock withRemoveFlag:YES];
}

+ (void)getNextPageRequestsWithPartitionRequestId:(NSInteger)rId
                                        descOrder:(BOOL)isDesc
                                     andPageCount:(NSUInteger)count
                                   andResultBlock:(GetRequestsDataResultBlock)resultBlock {
    NSString *sql = [NSString stringWithFormat:@"select * from t_requests order by rId %@ limit %lu",
                     isDesc ? @"desc" : @"asc", count + 1];
    if (rId > 0) {
        if (isDesc) {
            sql = [NSString stringWithFormat:@"select * from t_requests where rId < %ld order by rId %@ limit %lu",
                   rId, isDesc ? @"desc" : @"asc", count + 1];
        } else {
            sql = [NSString stringWithFormat:@"select * from t_requests where rId > %ld order by rId %@ limit %lu",
                   rId, isDesc ? @"desc" : @"asc", count + 1];
        }
    }
    
    [UBDRequestItemService getEventsDataWithSql:sql withCount:count andResultBlock:resultBlock withRemoveFlag:NO];
}

+ (void)getEventsDataWithSql:(NSString *)sql
                   withCount:(NSUInteger)count
              andResultBlock:(GetEventsDataResultBlock)resultBlock
              withRemoveFlag:(BOOL)removeHeader{
    [[UBDDatabaseService shareInstance].databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:sql];
        
        NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:count];
        while ([rs next]) {
            UBDRequestItem *item = [UBDRequestItemService getRequestItemFromResultSet:rs];
            if (item != nil) {
                [mArray addObject:item];
            }
        }
        
        if (resultBlock) {
            BOOL hasMore = NO;
            if (mArray.count > count) {
                hasMore = YES;
                if (removeHeader) {
                    [mArray removeObjectAtIndex:0];
                } else {
                    [mArray removeLastObject];
                }
            }
            
            resultBlock(mArray, hasMore);
        }
    }];
}

+ (UBDRequestItem *)getRequestItemFromResultSet:(FMResultSet *)rs {
    if (rs == nil) {
        return nil;
    }
    
    UBDRequestItem *requestItem = [[UBDRequestItem alloc] init];
    requestItem.rId = [rs intForColumn:@"rId"];
    requestItem.reqTs = [rs longLongIntForColumn:@"reqTs"];
    requestItem.resTs = [rs longLongIntForColumn:@"resTs"];
    requestItem.success = [rs boolForColumn:@"success"];
    requestItem.failReason = [rs stringForColumn:@"failReason"];
    
    return requestItem;
}

+ (void)findARequestItemWithId:(NSInteger)rId
                andResultBlock:(GetRequestsDataResultBlock)resultBlock {
    if (rId > 0) {
        [[UBDDatabaseService shareInstance].databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            NSString *sql = [NSString stringWithFormat:@"select * from t_requests where rId = %ld", rId];
            FMResultSet *rs = [db executeQuery:sql];
            if ([rs next]) {
                UBDRequestItem *item = [UBDRequestItemService getRequestItemFromResultSet:rs];
                resultBlock(@[item], NO);
            } else {
                resultBlock(nil, NO);
            }
        }];
    } else {
        resultBlock(nil, NO);
    }
}

@end
