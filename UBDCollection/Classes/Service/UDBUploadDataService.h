//
//  UDBUploadDataService.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/16.
//

#import "UBDBasicRequestService.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^UDBUploadDataResultBlock)(BOOL success, NSUInteger realCount, BOOL hasMoreData);

@interface UDBUploadDataService : UBDBasicRequestService

/// 上传指定条目数的日志数据
/// @param count 条目数
/// @param tag 请求标识tag
/// @param resultBlock 结果回调
- (void)uploadDataWithCount:(NSUInteger)count
                     andTag:(NSString *)tag
             andResultBlock:(UDBUploadDataResultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
