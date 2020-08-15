//
//  UBDBasicRequestService.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ERequestStatus) {
    eUnknown = 0,               // 未知状态
    eWaitingForSending,         // 等待发送
    eSending,                   // 发送中
    eSended,                    // 已发送
    eResponded                  // 已回应
};
typedef void(^UBDRequestReslutBlock)(id data, NSError *error);

@interface UBDBasicRequestService : NSObject

/// 发送指定参数的请求
/// @param params 指定参数
/// @param tag 请求标识tag
/// @param resultBlock 结果回调
- (void)sendRequestWithParam:(id)params
                      andTag:(NSString *)tag
              andResultBlock:(UBDRequestReslutBlock)resultBlock;

/// 获取指定请求的状态
/// @param tag 请求标识
- (ERequestStatus)requestStatusForTag:(NSString *)tag;

@end

NS_ASSUME_NONNULL_END
