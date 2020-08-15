//
//  UBDRequestItemService.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UBDRequestItem;
typedef void(^GetRequestsDataResultBlock)(NSArray<UBDRequestItem *> * _Nullable items, BOOL hasMore);
typedef void(^CreateRequestItemResultBlock)(UBDRequestItem * _Nullable item);
typedef void(^AddRequestItemResultBlock)(UBDRequestItem * _Nullable item);

/// 管理存放和获取请求信息的服务
@interface UBDRequestItemService : NSObject

/// 用户唯一标识
@property (nonatomic, strong) NSString *userId;
/// 当前app的tags（比如某个渠道号：应用宝渠道）
@property (nonatomic, strong) NSArray<NSString *> *tags;

/// 单例对象
+ (instancetype)shareInstance;

/// 构建一个可以发送count个事件的请求
/// @param count 指定包含的count个数
/// @param resultBlock 异步返回requestItem
+ (void)createARequestToSendEventsWithCount:(NSUInteger)count
                             andResultBlock:(CreateRequestItemResultBlock)resultBlock;

/// 清除所有日志
+ (void)clearRequests;

/// 分页获取数据时，获取上一页数据（结果按自增Id倒序排列，所以这里是获取时间戳更早的数据）
/// @param rId 当前数据的最大Id，返回的数据比这个Id更大
/// @param isDesc 是否按照入库顺序的倒序排列
/// @param count 要获取的数据条目数
/// @param resultBlock 异步结果回调
+ (void)getPreviousPageRequestsWithPartitionRequestId:(NSInteger)rId
                                            descOrder:(BOOL)isDesc
                                         andPageCount:(NSUInteger)count
                                       andResultBlock:(GetRequestsDataResultBlock)resultBlock;

/// 分页获取数据时，获取下一页数据（结果按自增Id倒序排列，所以这里是获取时间戳更晚的数据）
/// @param rId 当前数据的最小Id，返回的数据比这个Id更小
/// @param isDesc 是否按照入库顺序的倒序排列
/// @param count 要获取的数据条目数
/// @param resultBlock 异步结果回调
+ (void)getNextPageRequestsWithPartitionRequestId:(NSInteger)rId
                                        descOrder:(BOOL)isDesc
                                     andPageCount:(NSUInteger)count
                                   andResultBlock:(GetRequestsDataResultBlock)resultBlock;

/// 根据请求Id找到请求信息
/// @param rId 请求Id
/// @param resultBlock 结果回调
+ (void)findARequestItemWithId:(NSInteger)rId
                andResultBlock:(GetRequestsDataResultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
