//
//  UBDRequestDispatcher.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/18.
//

#import "UBDRequestDispatcher.h"
#import "UBDUploadStrategyBase.h"

@interface UBDRequestDispatcher ()

@property (nonatomic, strong) UBDUploadStrategyBase *uploadStrategy;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation UBDRequestDispatcher

+ (instancetype)shareInstanceWithUploadStrategy:(UBDUploadStrategyBase *)uploadStrategy {
    static UBDRequestDispatcher *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[UBDRequestDispatcher alloc] initWithUploadStrategy:uploadStrategy];
    });
    
    return sInstance;
}

- (instancetype)init {
    NSAssert(NO, @"请使用单例对象，以保证请求成链，便于打点完整性校验");
    return nil;
}

- (instancetype)initWithUploadStrategy:(UBDUploadStrategyBase *)uploadStrategy {
    if (self = [super init]) {
        self.uploadStrategy = uploadStrategy;
    }
    
    return self;
}

- (void)addAEvent:(UBDEventItem *)eventItem {
    //
}

- (void)tryToSendEventsInfo {
    //
}

@end
