//
//  UBDEventItemService.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/3.
//

#import "UBDEventItemService.h"

@implementation UBDEventItemService

+ (instancetype)shareInstance {
    static UBDEventItemService *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[UBDEventItemService alloc] init];
    });
    
    return sInstance;
}

+ (void)addEvent:(UBDEventItem *)item {
    //
}

+ (void)removeEventWithId:(NSInteger)eId {
    //
}

+ (void)getEventsWithCount:(NSUInteger)count andResultBlock:(GetEventsDataResultBlock)resultBlock {
    //
}

+ (void)getEventsWithIds:(NSArray<NSNumber *> *)ids andResultBlock:(GetEventsDataResultBlock)resultBlock {
    //
}

+ (void)clearEvents {
    //
}

+ (void)getPreviousPageEventsWithPartitionEventId:(NSInteger)eId
                                     andPageCount:(NSUInteger)count
                                   andResultBlock:(GetEventsDataResultBlock)resultBlock {
    //
}

+ (void)getNextPageEventsWithPartitionEventId:(NSInteger)eId
                                 andPageCount:(NSUInteger)count
                               andResultBlock:(GetEventsDataResultBlock)resultBlock {
    //
}

@end
