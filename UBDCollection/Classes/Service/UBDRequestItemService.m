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
        
        FMResultSet *set = [db executeQuery:@"select * from t_events where rowid = last_insert_rowid()"];
        if ([set next]) {
            item.rId = [set intForColumn:@"rId"];
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
                     (appVersion, osVersion, networkType, deviceId, userId, tags, preTs, curTs, rId) values (%@, %@, %@, %@, %@, %@, %ld, %ld, %ld)",
                     item.appVersion, item.osVersion, item.networkType, item.deviceId, item.userId ? item.userId : @"''",
                     tags ? tags : @"''", item.preTs, item.curTs, item.rId];
    [[UBDDatabaseService shareInstance].databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:sql];
    }];
}

+ (void)clearRequests {
    //
}

+ (void)getPreviousPageRequestsWithPartitionRequestId:(NSInteger)rId
                                         andPageCount:(NSUInteger)count
                                       andResultBlock:(GetRequestsDataResultBlock)resultBlock {
    //
}

+ (void)getNextPageRequestsWithPartitionRequestId:(NSInteger)rId
                                     andPageCount:(NSUInteger)count
                                   andResultBlock:(GetRequestsDataResultBlock)resultBlock {
    //
}

@end
