//
//  UBDEventItemService.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UBDEventItem;
typedef void(^GetEventsDataResultBlock)(NSArray<UBDEventItem *> *items, BOOL hasMore);

/// 管理存放和获取行为日志的服务
@interface UBDEventItemService : NSObject

/// 单例对象
+ (instancetype)shareInstance;

/// 添加一条行为日志
/// @param item 日志条目
+ (void)addEvent:(UBDEventItem *)item;

/// 删除一条行为日志
/// @param eId 指定日志Id
+ (void)removeEventWithId:(NSInteger)eId;

/// 获取指定数量的行为日志信息
/// @param count 指定数量
/// @param resultBlock 异步结果回调
+ (void)getEventsWithCount:(NSUInteger)count
            andResultBlock:(GetEventsDataResultBlock)resultBlock;

/// 根据Id获取行为日志信息
/// @param ids 指定Ids
/// @param resultBlock 异步结果回调
+ (void)getEventsWithIds:(NSArray<NSNumber *> *)ids
          andResultBlock:(GetEventsDataResultBlock)resultBlock;

/// 清除所有日志
+ (void)clearEvents;

/// 分页获取数据时，获取上一页数据（结果按自增Id倒序排列，所以这里是获取时间戳更早的数据）
/// @param eId 当前数据的最大Id，返回的数据比这个Id更大
/// @param count 要获取的数据条目数
/// @param resultBlock 异步结果回调
+ (void)getPreviousPageEventsWithPartitionEventId:(NSInteger)eId
                                     andPageCount:(NSUInteger)count
                                   andResultBlock:(GetEventsDataResultBlock)resultBlock;

/// 分页获取数据时，获取下一页数据（结果按自增Id倒序排列，所以这里是获取时间戳更晚的数据）
/// @param eId 当前数据的最小Id，返回的数据比这个Id更小
/// @param count 要获取的数据条目数
/// @param resultBlock 异步结果回调
+ (void)getNextPageEventsWithPartitionEventId:(NSInteger)eId
                                 andPageCount:(NSUInteger)count
                               andResultBlock:(GetEventsDataResultBlock)resultBlock;
@end

NS_ASSUME_NONNULL_END
