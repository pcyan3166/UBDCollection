//
//  UDBUploadDataService.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/16.
//

#import "UDBUploadDataService.h"
#import "UBDEventItem.h"
#import "UBDEventsPackage.h"
#import "UBDRequestItem.h"
#import "UBDEventItemService.h"
#import "UBDRequestItemService.h"

@implementation UDBUploadDataService

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
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    return mDic;
}

@end
