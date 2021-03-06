//
//  UBDEventItem.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, ESendStatus) {
    eSendStatusUnknown =          0,          // 初始值，未知状态
    eSendStatusSending =          0 << 1,     // 发送中
    eSendStatusFinished =         1 << 1,     // 收到响应，发送完成
    eSendStatusAllStatus =        0xFFFFFFFF  // 所有状态
};

typedef NS_ENUM(Byte, EEventType) {
    eClickEvent = 0,
    eShowEvent,
    eEnterPageEvent,
    eAllEvents
};

/// 存储事件的数据结构
@interface UBDEventItem : NSObject

/// 数据库中的Id
@property (nonatomic, assign) NSInteger eId;
/// 事件发生的时间戳（精确到毫秒）
@property (nonatomic, assign) NSInteger ts;
/// 模块Id
@property (nonatomic, assign) NSInteger moduleId;
/// 页面Id
@property (nonatomic, assign) NSInteger pageId;
/// 页面深度（在当前页面栈中的位置信息，用于在上下文中识别是跳转下一级还是返回上一级）
@property (nonatomic, assign) NSInteger pLevel;
/// 事件Id
@property (nonatomic, assign) NSInteger eventId;
/// 事件类型
@property (nonatomic, assign) EEventType eventType;
/// 额外参数（建议以Json String的形式存储，数据不宜过长，不要超过1024个字符）
@property (nonatomic, strong) NSString *extraInfo;
/// 发送状态
@property (nonatomic, assign) ESendStatus sendStatus;
/// 是否实时发送（YES为实时，NO为非实时）
@property (nonatomic, assign) BOOL realTime;
/// 外键：请求Id，用于校验检查点是否被正确打上
@property (nonatomic, assign) NSInteger rId;

@end

NS_ASSUME_NONNULL_END
