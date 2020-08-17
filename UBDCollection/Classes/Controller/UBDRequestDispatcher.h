//
//  UBDRequestDispatcher.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UBDUploadStrategyBase;
@class UBDEventItem;
@interface UBDRequestDispatcher : NSObject

/// 单例对象
+ (instancetype)shareInstanceWithUploadStrategy:(UBDUploadStrategyBase *)uploadStrategy;

/// 禁止用户创建对象，只允许使用单例对象
- (instancetype)init NS_UNAVAILABLE;

/// 添加一个事件
/// @param eventItem 事件信息
- (void)addAEvent:(UBDEventItem *)eventItem;

/// 尝试立刻发出事件请求，不一定能立刻发送（如果当前有请求正在发送中，则等前一个请求发完再尝试发送）
- (void)tryToSendEventsInfo;

@end

NS_ASSUME_NONNULL_END
