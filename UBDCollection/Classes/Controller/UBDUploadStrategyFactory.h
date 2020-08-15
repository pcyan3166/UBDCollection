//
//  UBDUploadStrategyFactory.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/16.
//

#import <Foundation/Foundation.h>
#import "UBDUploadStrategyDef.h"

NS_ASSUME_NONNULL_BEGIN
@class UBDUploadStrategyBase;
@interface UBDUploadStrategyFactory : NSObject

+ (UBDUploadStrategyBase * _Nullable)createUploadStrategyWithUploadStrategy:(EUploadStrategyType)uploadStrategy;

@end

NS_ASSUME_NONNULL_END
