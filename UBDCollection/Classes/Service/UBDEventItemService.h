//
//  UBDEventItemService.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/3.
//

#import <Foundation/Foundation.h>
#import "UBDEventItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GetEventsDataResultBlock)(NSArray<UBDEventItem *> * _Nullable items, BOOL hasMore);
typedef void(^AddEventsDataResultBlock)(UBDEventItem *items);
typedef void(^GetEventCountResultBlock)(NSUInteger count);

/// 管理存放和获取行为日志的服务
@interface UBDEventItemService : NSObject

/// 添加一条行为日志
/// @param item 日志条目
+ (void)addEvent:(UBDEventItem *)item;

/// 添加一条行为日志
/// @param item 日志条目
/// @param result 添加成功后的回调（可以在这里获取到eId）
+ (void)addEvent:(UBDEventItem *)item withResult:(AddEventsDataResultBlock)result;

/// 删除一条行为日志
/// @param eId 指定日志Id
+ (void)removeEventWithId:(NSInteger)eId;

/// 清除指定requestId对应的日志
/// @param rId 指定requestId，如果rId <= 0；则清除所有数据
+ (void)removeEventsWithRequestId:(NSInteger)rId;

/// 清除所有日志
+ (void)clearEvents;

/// 为一系列events更新requestId
/// @param rId 更新的目标requestId值
/// @param events 需要更新的events
+ (void)updateRequestId:(NSInteger)rId forEvents:(NSArray<UBDEventItem *> *)events;

/// 根据requestId获取该批上传的日志信息
/// @param rId 指定批次的requestId
/// @param resultBlock 结果回调
+ (void)getEventsWithRequestId:(NSInteger)rId
                andResultBlock:(GetEventsDataResultBlock)resultBlock;

/// 获取指定状态的日志信息条目数
/// @param sendStatus 发送状态
/// @param reslutBlock 结果回调
+ (void)getEventsCountWithStatus:(ESendStatus)sendStatus
                  andResultBlock:(GetEventCountResultBlock)reslutBlock;

/// 更新指定的事件的状态
/// @param fromStatus 需要更新的状态
/// @param toStatus 更新的目的状态
/// @param events 指定需要更新哪些条目，如果为空，则更新所有满足状态条件的条目
+ (void)updateSendStatus:(ESendStatus)fromStatus
                toStatus:(ESendStatus)toStatus
               forEvents:(NSArray<UBDEventItem *> * _Nullable)events;

/// 分页获取数据时，获取上一页数据（结果按自增Id倒序排列，所以这里是获取时间戳更早的数据）
/// @param eId 当前数据的最大Id，返回的数据比这个Id更大
/// @param isDesc 是否按照入库顺序的倒序排列
/// @param count 要获取的数据条目数
/// @param resultBlock 异步结果回调
+ (void)getPreviousPageEventsWithPartitionEventId:(NSInteger)eId
                                        descOrder:(BOOL)isDesc
                                     andPageCount:(NSUInteger)count
                                   andResultBlock:(GetEventsDataResultBlock)resultBlock;

/// 分页获取数据时，获取下一页数据（结果按自增Id倒序排列，所以这里是获取时间戳更晚的数据）
/// @param eId 当前数据的最小Id，返回的数据比这个Id更小
/// @param isDesc 是否按照入库顺序的倒序排列
/// @param count 要获取的数据条目数
/// @param resultBlock 异步结果回调
+ (void)getNextPageEventsWithPartitionEventId:(NSInteger)eId
                                    descOrder:(BOOL)isDesc
                                 andPageCount:(NSUInteger)count
                               andResultBlock:(GetEventsDataResultBlock)resultBlock;

/// 根据相关条件获取数据
/// @param moduleId 模块Id，小于0时忽略该条件以支持模糊查询
/// @param pageId 页面Id，小于0时忽略该条件以支持模糊查询
/// @param eventId 事件Id，小于0时忽略该条件以支持模糊查询
/// @param eventType 事件类型，eAllEvents时忽略该条件以支持模糊查询
/// @param resultBlock 结果回调
+ (void)findAEventsWithModuleId:(NSInteger)moduleId
                      andPageId:(NSInteger)pageId
                     andEventId:(NSInteger)eventId
                   andEventType:(EEventType)eventType
                 andResultBlock:(GetEventsDataResultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
