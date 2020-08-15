//
//  UBDUploadStrategyFactory.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/16.
//

#import "UBDUploadStrategyFactory.h"
#import "UBDRadicalUploadStrategy.h"
#import "UBDMiddleUploadStrategy.h"
#import "UBDLazyUploadStrategy.h"

@implementation UBDUploadStrategyFactory

+ (UBDUploadStrategyBase *)createUploadStrategyWithUploadStrategy:(EUploadStrategyType)uploadStrategy {
    switch (uploadStrategy) {
        case eRadicalUpload:
            return [[UBDRadicalUploadStrategy alloc] init];
        case eMiddleUpload:
            return [[UBDMiddleUploadStrategy alloc] init];
        case eLazyUpload:
            return [[UBDLazyUploadStrategy alloc] init];
        default:
            return nil;
    }
}

@end
