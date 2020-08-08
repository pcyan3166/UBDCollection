//
//  UBDPageInfoProtocol.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UBDPageInfoProtocol <NSObject>

/// 返回当前页面的模块Id信息
- (NSInteger)moduleId;

/// 返回当前页面的页面Id信息
- (NSInteger)pageId;

@end

NS_ASSUME_NONNULL_END
