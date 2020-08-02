//
//  UBDEventItemService.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UBDEventItem;
typedef void(^GetEventsDataResultBlock)(NSArray<UBDEventItem *> *items);

@interface UBDEventItemService : NSObject

+ (void)addEvent:(UBDEventItem *)item;
+ (void)removeEventWithId:(NSInteger)eId;
+ (void)getEventsWithCount:(NSUInteger)count andResultBlock:(GetEventsDataResultBlock)resultBlock;
+ (void)getEventsWithIds:(NSArray<NSNumber *> *)ids andResultBlock:(GetEventsDataResultBlock)resultBlock;
+ (void)clearEvents;

@end

NS_ASSUME_NONNULL_END
