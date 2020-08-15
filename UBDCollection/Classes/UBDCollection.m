//
//  UBDCollection.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/3.
//

#import "UBDCollection.h"
#import "UBDUploadStrategyBase.h"
#import "UBDUploadStrategyFactory.h"

@interface UBDCollection ()

@property(nonatomic, strong) UBDUploadStrategyBase *uploadStrategy;

@end

@implementation UBDCollection

+ (instancetype)shareInstance {
    static UBDCollection *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[UBDCollection alloc] init];
    });
    
    return sInstance;
}

- (void)startCollectionWithUploadStrategy:(EUploadStrategyType)uploadStrategy {
    self.uploadStrategy = [UBDUploadStrategyFactory createUploadStrategyWithUploadStrategy:uploadStrategy];
}

@end
