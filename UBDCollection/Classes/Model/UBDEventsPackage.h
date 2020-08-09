//
//  UBDEventsPackage.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UBDEventItem;
/// 每次请求的数据包
@interface UBDEventsPackage : NSObject

#pragma mark - 公共字段
/// app 唯一标识
@property (nonatomic, strong) NSString *appId;
/// app当前的版本号（2.2.2.95）
@property (nonatomic, strong) NSString *appVersion;
/// 当前操作系统类型（iOS，Android，Symbian，Mac OS，Windows，Linux，Windows Phone等）
@property (nonatomic, strong) NSString *osType;
/// 操作系统版本（iOS 13.4.6）
@property (nonatomic, strong) NSString *osVersion;
/// 设备品牌（iPhone，华为，三星、小米、魅族，锤子等）
@property (nonatomic, strong) NSString *deviceBrand;
/// 设备具体型号（iPhone 11 Pro，华为 P40 Pro）
@property (nonatomic, strong) NSString *deviceType;
/// 当前网络条件（WIFI，5G，4G，3G，2G）
@property (nonatomic, strong) NSString *networkType;
/// 设备号（唯一标识一台设备，最好长时间保持不变）
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
/// 外键：请求Id，用于校验检查点是否被正确打上
@property (nonatomic, assign) NSInteger rId;

@end

NS_ASSUME_NONNULL_END
