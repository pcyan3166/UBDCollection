//
//  UBDBasicRequestService.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/16.
//

#import "UBDBasicRequestService.h"

@interface UBDBasicRequestService ()

@property (nonatomic, strong)NSDictionary *requestStatusInfo;

@end

@implementation UBDBasicRequestService

- (void)sendRequestWithParam:(id)params
                      andTag:(NSString *)tag
              andResultBlock:(UBDRequestReslutBlock)resultBlock {
    if (tag.length > 0) {
        //
    }
}

- (void)updateStatus:(ERequestStatus)requestStatus forTag:(NSString *)tag {
    if (tag.length > 0) {
        @synchronized (self.requestStatusInfo) {
            NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:_requestStatusInfo];
            mDic[tag] = @(requestStatus);
            
            _requestStatusInfo = mDic;
        }
    }
}

- (ERequestStatus)requestStatusForTag:(NSString *)tag {
    if (tag.length > 0) {
        return [self.requestStatusInfo[tag] integerValue];
    }
    
    return eRequestStatusUnknown;
}

- (NSDictionary *)requestStatusInfo {
    if (_requestStatusInfo == nil) {
        _requestStatusInfo = @{};
    }
    
    return _requestStatusInfo;
}

@end
