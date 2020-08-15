//
//  UBDUploadStrategyBase.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UBDUploadStrategyBase : NSObject

/// wifi网路下的参数
/// 触发日志上传操作的日志条数
@property (nonatomic, assign) NSUInteger triggerEventsCountOnWifi;
/// App到前台后，延迟多长时间上传日志信息（避免启动时占用业务带宽）
@property (nonatomic, assign) NSUInteger uploadDelayAfterAppActiveOnWifi;
/// 每次上传好日志信息后，下次隔多长时间再上传
@property (nonatomic, assign) NSUInteger uploadTimeGapOnWifi;
/// 每次上传的日志的条数
@property (nonatomic, assign) NSUInteger uploadEventMaxCountPerTimeOnWifi;
/// 如果发现有更多数据，上次上传后延迟多少时间继续上传数据
@property (nonatomic, assign) NSUInteger uploadDelayTimeIfThereIsMoreDataOnWifi;


/// 快移动网络下的参数（4G及以上：4G、5G等）
/// 触发日志上传操作的日志条数
@property (nonatomic, assign) NSUInteger triggerEventsCountOnFastWWAN;
/// App到前台后，延迟多长时间上传日志信息（避免启动时占用业务带宽）
@property (nonatomic, assign) NSUInteger uploadDelayAfterAppActiveOnFastWWAN;
/// 每次上传好日志信息后，下次隔多长时间再上传
@property (nonatomic, assign) NSUInteger uploadTimeGapOnFastWWAN;
/// 每次上传的日志的条数
@property (nonatomic, assign) NSUInteger uploadEventMaxCountPerTimeOnFastWWAN;
/// 如果发现有更多数据，上次上传后延迟多少时间继续上传数据
@property (nonatomic, assign) NSUInteger uploadDelayTimeIfThereIsMoreDataOnFastWWAN;


/// 慢移动网络下的参数（4G以下：2G、3G等）
/// 触发日志上传操作的日志条数
@property (nonatomic, assign) NSUInteger triggerEventsCountOnSlowWWAN;
/// App到前台后，延迟多长时间上传日志信息（避免启动时占用业务带宽）
@property (nonatomic, assign) NSUInteger uploadDelayAfterAppActiveOnSlowWWAN;
/// 每次上传好日志信息后，下次隔多长时间再上传
@property (nonatomic, assign) NSUInteger uploadTimeGapOnSlowWWAN;
/// 每次上传的日志的条数
@property (nonatomic, assign) NSUInteger uploadEventMaxCountPerTimeOnSlowWWAN;
/// 如果发现有更多数据，上次上传后延迟多少时间继续上传数据
@property (nonatomic, assign) NSUInteger uploadDelayTimeIfThereIsMoreDataOnSlowWWAN;

@end

NS_ASSUME_NONNULL_END
