//
//  UBDRequestDispatcher.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/18.
//

#import "UBDRequestDispatcher.h"
#import "UBDUploadStrategyBase.h"
#import "UBDUploadDataService.h"
#import <BasicTools/NetworkService.h>

#define UPLOAD_REQUEST_TAG  @"uploadRequestTag"

@interface UBDRequestDispatcher ()

@property (nonatomic, strong) UBDUploadStrategyBase *uploadStrategy;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UBDUploadDataService *uploadDataService;
@property (nonatomic, assign) BOOL needUploadNow;

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
        self.uploadDataService = [[UBDUploadDataService alloc] init];
    }
    
    return self;
}

- (void)addAEvent:(UBDEventItem *)eventItem {
    //
}

- (void)tryToSendEventsInfo {
    if ([self.uploadDataService requestStatusForTag:UPLOAD_REQUEST_TAG] != eRequestStatusSending) {
        NSUInteger count = [self sendCountForCurrentNetWorkType];
        if (count > 0) {
            [self.uploadDataService uploadDataWithCount:count andTag:UPLOAD_REQUEST_TAG andResultBlock:^(BOOL success, NSUInteger realCount, BOOL hasMoreData) {
                //
            }];
        } else {
            self.needUploadNow = YES;
        }
    }
}

- (NSUInteger)sendCountForCurrentNetWorkType {
    switch ([NetworkService micromeshShareInstance].networkStatus) {
        case eNetworkStatus2G:
        case eNetworkStatus3G:
            return self.uploadStrategy.triggerEventsCountOnSlowWWAN;
        case eNetworkStatus4G:
            return self.uploadStrategy.triggerEventsCountOnFastWWAN;
        case eNetworkStatusWifi:
        case eNetworkStatusUnkown:
            return self.uploadStrategy.triggerEventsCountOnWifi;
        default:
            return 0;
    }
}

@end
