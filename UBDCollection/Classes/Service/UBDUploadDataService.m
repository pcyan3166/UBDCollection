//
//  UDBUploadDataService.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/16.
//

#import "UBDUploadDataService.h"
#import "UBDEventItem.h"
#import "UBDEventsPackage.h"
#import "UBDRequestItem.h"
#import "UBDEventItemService.h"
#import "UBDRequestItemService.h"

#define COMMON_INFO_KEY @"common"
#define EVENTS_INFO_KEY @"events"

@implementation UBDUploadDataService

- (void)uploadDataWithCount:(NSUInteger)count andTag:(NSString *)tag andResultBlock:(UDBUploadDataResultBlock)resultBlock {
    [UBDRequestItemService createARequestToSendEventsWithCount:count andResultBlock:^(UBDRequestItem * _Nullable item, BOOL hasMore) {
        if (item != nil) {
            NSDictionary *paramDic = [self setupParamWithRequestItem:item];
            [self sendRequestWithParam:paramDic andTag:tag andResultBlock:^(id  _Nonnull data, NSError * _Nonnull error) {
                if (error == nil && data != nil) {
                    resultBlock(YES, item.eventPackage.events.count, YES);
                } else {
                    resultBlock(NO, 0, YES);
                }
            }];
        } else {
            resultBlock(YES, 0, NO);
        }
    }];
}

- (NSDictionary *)setupParamWithRequestItem:(UBDRequestItem *)item {
    if (self.packager != nil && [self.packager respondsToSelector:@selector(packageDataWithRequestItem:)]) {
        return [self.packager packageDataWithRequestItem:item];
    } else {
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
        
        NSMutableDictionary *mCommonDic = [[NSMutableDictionary alloc] init];
        mCommonDic[@"appId"] = item.eventPackage.appId;
        mCommonDic[@"appVersion"] = item.eventPackage.appVersion;
        mCommonDic[@"osType"] = item.eventPackage.osType;
        mCommonDic[@"osVersion"] = item.eventPackage.osVersion;
        mCommonDic[@"deviceBrand"] = item.eventPackage.deviceBrand;
        mCommonDic[@"deviceType"] = item.eventPackage.deviceType;
        mCommonDic[@"networkType"] = item.eventPackage.networkType;
        mCommonDic[@"deviceId"] = item.eventPackage.deviceId;
        mCommonDic[@"userId"] = item.eventPackage.userId == nil ? @"" : item.eventPackage.userId;
        mCommonDic[@"tags"] = item.eventPackage.tags.count > 0 ? @[] : item.eventPackage.tags;
        mCommonDic[@"preTs"] = @(item.eventPackage.preTs);
        mCommonDic[@"curTs"] = @(item.eventPackage.curTs);
        mDic[COMMON_INFO_KEY] = mCommonDic;
        
        NSMutableArray *mEventsArray = [[NSMutableArray alloc] initWithCapacity:item.eventPackage.events.count];
        for (UBDEventItem *eventItem in item.eventPackage.events) {
            NSMutableDictionary *mEventItemDic = [[NSMutableDictionary alloc] init];
            mEventItemDic[@"ts"] = @(eventItem.ts);
            mEventItemDic[@"moduleId"] = @(eventItem.moduleId);
            mEventItemDic[@"pageId"] = @(eventItem.pageId);
            mEventItemDic[@"pLevel"] = @(eventItem.pLevel);
            mEventItemDic[@"eventId"] = @(eventItem.eventId);
            mEventItemDic[@"eventType"] = @(eventItem.eventType);
            mEventItemDic[@"extraInfo"] = eventItem.extraInfo;
            [mEventsArray addObject:mEventItemDic];
        }
        mDic[EVENTS_INFO_KEY] = mEventsArray;
        
        return mDic;
    }
}

@end
