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
                                                 andResultBlock:^(UBDRequestItem * _Nullable item, BOOL hasMore) {
                    resultBlock(item, hasMore);
                }];
            } else {
                resultBlock(nil, NO);
            }
        }];
    } else {
        resultBlock(nil, NO);
    }
}

+ (void)createARequestWithEvents:(NSArray<UBDEventItem *> * _Nonnull)items
                  andResultBlock:(CreateRequestItemResultBlock)resultBlock {
    if (items.count > 0) {
        UBDEventsPackage *package = [UBDRequestItemService createAPackageWithEvents:items];
        UBDRequestItem *requestItem = [[UBDRequestItem alloc] init];
        requestItem.eventPackage = package;
        
        resultBlock(requestItem, NO);
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
        
        package.events = items;
    }
    
    return nil;
}

+ (void)addEvent:(UBDRequestItem *)item {
    //
}

+ (void)removeEventWithId:(NSInteger)rId {
    //
}

+ (void)getEventsWithCount:(NSUInteger)count
            andResultBlock:(GetRequestsDataResultBlock)resultBlock {
    //
}

+ (void)getEventsWithIds:(NSArray<NSNumber *> *)ids
          andResultBlock:(GetRequestsDataResultBlock)resultBlock {
    //
}

+ (void)clearEvents {
    //
}

+ (void)getPreviousPageEventsWithPartitionEventId:(NSInteger)rId
                                     andPageCount:(NSUInteger)count
                                   andResultBlock:(GetRequestsDataResultBlock)resultBlock {
    //
}

+ (void)getNextPageEventsWithPartitionEventId:(NSInteger)rId
                                 andPageCount:(NSUInteger)count
                               andResultBlock:(GetRequestsDataResultBlock)resultBlock {
    //
}

@end
