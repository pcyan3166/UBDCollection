//
//  UBDCollection.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/3.
//

#import <Foundation/Foundation.h>
#import "UBDUploadStrategyDef.h"

NS_ASSUME_NONNULL_BEGIN

@interface UBDCollection : NSObject

/// 单例对象
+ (instancetype)shareInstance;

/// 选择日志上传策略启动日志自动上传功能
/// @param uploadStrategy 日志上传策略
- (void)startCollectionWithUploadStrategy:(EUploadStrategyType)uploadStrategy;

@end

NS_ASSUME_NONNULL_END
