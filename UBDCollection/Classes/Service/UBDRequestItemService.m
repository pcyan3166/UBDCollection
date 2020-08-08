//
//  UBDRequestItemService.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/3.
//

#import "UBDRequestItemService.h"

@implementation UBDRequestItemService

+ (instancetype)shareInstance {
    static UBDRequestItemService *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[UBDRequestItemService alloc] init];
    });
    
    return sInstance;
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
