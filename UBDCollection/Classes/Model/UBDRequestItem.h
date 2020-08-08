//
//  UBDRequestItem.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/7/18.
//

#import <Foundation/Foundation.h>
#import "UBDEventItem.h"

NS_ASSUME_NONNULL_BEGIN

@class UBDEventsPackage;

/// 存储请求信息的数据结构
@interface UBDRequestItem : NSObject

/// 请求信息存放在数据库的Id
@property (nonatomic, assign) NSInteger rId;

/// 请求发起的时间戳
@property (nonatomic, assign) NSTimeInterval reqTs;

/// 收到响应的时间戳
@property (nonatomic, assign) NSTimeInterval resTs;

/// 是否成功（YES为成功，NO为不成功）
@property (nonatomic, assign) BOOL success;

/// 请求失败的原因
@property (nonatomic, strong) NSString *failReason;

/// 本次上传的数据包
@property (nonatomic, strong) UBDEventsPackage *eventPackage;

@end

NS_ASSUME_NONNULL_END
