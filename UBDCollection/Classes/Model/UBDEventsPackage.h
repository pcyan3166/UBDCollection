//
//  UBDEventsPackage.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UBDEventItem;
@interface UBDEventsPackage : NSObject

#pragma mark - 公共字段
/// app 唯一标识
@property (nonatomic, strong) NSString *appId;
/// app当前的版本号（2.2.2.95）
@property (nonatomic, strong) NSString *appVersion;
/// 操作系统类型（iOS，Android，Windows）
@property (nonatomic, strong) NSString *osType;
/// 操作系统版本（iOS 13.4.6）
@property (nonatomic, strong) NSString *osVersion;
/// 设备品牌（iPhone，华为，三星）
@property (nonatomic, strong) NSString *deviceBrand;
/// 设备类型（iPhone 4S）
@property (nonatomic, strong) NSString *deviceType;
/// 当前网络类型
@property (nonatomic, strong) NSString *networkType;
/// 设备唯一标识
@property (nonatomic, strong) NSString *deviceId;
/// 用户唯一标识
@property (nonatomic, strong) NSString *userId;
/// 当前app的tags（比如某个渠道号：应用宝渠道）
@property (nonatomic, strong) NSArray<NSString *> *tags;

#pragma mark - 校验字段

/// 上一次请求的时间戳
@property (nonatomic, assign) NSTimeInterval preTs;
/// 当前这次请求的时间戳
@property (nonatomic, assign) NSTimeInterval curTs;

#pragma mark - evnets 数据
/// 本次包装的事件信息
@property (nonatomic, strong) NSArray<UBDEventItem *> *events;

@end

NS_ASSUME_NONNULL_END
