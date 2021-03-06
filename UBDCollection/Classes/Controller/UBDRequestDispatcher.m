//
//  UBDRequestDispatcher.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/18.
//

#import "UBDRequestDispatcher.h"
#import "UBDUploadStrategyBase.h"
#import "UBDUploadDataService.h"
#import "UBDEventItemService.h"
#import <BasicTools/NetworkService.h>

#define UPLOAD_REQUEST_TAG  @"uploadRequestTag"

@interface UBDRequestDispatcher ()

/// 上传策略
@property (nonatomic, strong) UBDUploadStrategyBase *uploadStrategy;
/// 数据上传服务
@property (nonatomic, strong) UBDUploadDataService *uploadDataService;
/// 立即上传标记（上次上传成功后，发现这个标记，立即发送下一波数据）
@property (nonatomic, assign) BOOL needUploadNow;

/// app当前是否在激活状态
@property (nonatomic, assign) BOOL appIsActive;
/// 当前是否为app激活后第一次上传的请求，为了避免占用启动带宽，第一次请求有单独的上传延时
@property (nonatomic, assign) BOOL firstUploadAfterActive;

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        
        // 初始化时，可能已经错过了第一次通知，所以手动启一次
        [self applicationDidBecomeActive];
    }
    
    return self;
}

- (void)applicationDidBecomeActive {
    if (!_appIsActive) {
        _appIsActive = YES;
        
        _firstUploadAfterActive = YES;
        [self tryToSendEventsInfoAfterDelay:[self uploadDelayAfterAppActiveForCurrentNetWorkType]];
    }
}

- (void)applicationWillResignActive {
    _appIsActive = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tryToSendEventsInfo) object:nil];
}

- (void)addAEvent:(UBDEventItem *)eventItem {
    [UBDEventItemService addEvent:eventItem];
    
    __weak typeof(self) weakSelf = self;
    [UBDEventItemService getEventsCountWithStatus:eSendStatusUnknown andResultBlock:^(NSUInteger count) {
        if (count >= [weakSelf triggerEventsCountForCurrentNetWorkType]) {
            [weakSelf tryToSendEventsInfoAfterDelay:0];
        }
    }];
}

- (void)tryToSendEventsInfoAfterDelay:(NSUInteger)seconds {
    if (seconds != 0) {
        [self performSelector:@selector(tryToSendEventsInfo) withObject:nil afterDelay:seconds];
    } else {
        [self tryToSendEventsInfo];
    }
}

- (void)tryToSendEventsInfo {
    if ([self.uploadDataService requestStatusForTag:UPLOAD_REQUEST_TAG] != eRequestStatusSending) {
        __weak typeof(self) weakSelf = self;
        NSUInteger count = [self uploadEventMaxCountPerTimeForCurrentNetWorkType];
        if (count > 0) {
            [self.uploadDataService uploadDataWithCount:count andTag:UPLOAD_REQUEST_TAG andResultBlock:^(BOOL success, NSUInteger realCount, BOOL hasMoreData) {
                if (hasMoreData) {
                    //
                } else {
                    //
                }
            }];
        } else {
            self.needUploadNow = YES;
        }
    }
}

- (NSUInteger)triggerEventsCountForCurrentNetWorkType {
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

- (NSUInteger)uploadDelayAfterAppActiveForCurrentNetWorkType {
    switch ([NetworkService micromeshShareInstance].networkStatus) {
        case eNetworkStatus2G:
        case eNetworkStatus3G:
            return self.uploadStrategy.uploadDelayAfterAppActiveOnSlowWWAN;
        case eNetworkStatus4G:
            return self.uploadStrategy.uploadDelayAfterAppActiveOnFastWWAN;
        case eNetworkStatusWifi:
        case eNetworkStatusUnkown:
            return self.uploadStrategy.uploadDelayAfterAppActiveOnWifi;
        default:
            return 0;
    }
}

- (NSUInteger)uploadTimeGapForCurrentNetWorkType {
    switch ([NetworkService micromeshShareInstance].networkStatus) {
        case eNetworkStatus2G:
        case eNetworkStatus3G:
            return self.uploadStrategy.uploadTimeGapOnSlowWWAN;
        case eNetworkStatus4G:
            return self.uploadStrategy.uploadTimeGapOnFastWWAN;
        case eNetworkStatusWifi:
        case eNetworkStatusUnkown:
            return self.uploadStrategy.uploadTimeGapOnWifi;
        default:
            return 0;
    }
}

- (NSUInteger)uploadEventMaxCountPerTimeForCurrentNetWorkType {
    switch ([NetworkService micromeshShareInstance].networkStatus) {
        case eNetworkStatus2G:
        case eNetworkStatus3G:
            return self.uploadStrategy.uploadEventMaxCountPerTimeOnSlowWWAN;
        case eNetworkStatus4G:
            return self.uploadStrategy.uploadEventMaxCountPerTimeOnFastWWAN;
        case eNetworkStatusWifi:
        case eNetworkStatusUnkown:
            return self.uploadStrategy.uploadEventMaxCountPerTimeOnWifi;
        default:
            return 0;
    }
}

- (NSUInteger)uploadDelayTimeIfThereIsMoreDataForCurrentNetWorkType {
    switch ([NetworkService micromeshShareInstance].networkStatus) {
        case eNetworkStatus2G:
        case eNetworkStatus3G:
            return self.uploadStrategy.uploadDelayTimeIfThereIsMoreDataOnSlowWWAN;
        case eNetworkStatus4G:
            return self.uploadStrategy.uploadDelayTimeIfThereIsMoreDataOnFastWWAN;
        case eNetworkStatusWifi:
        case eNetworkStatusUnkown:
            return self.uploadStrategy.uploadDelayTimeIfThereIsMoreDataOnWifi;
        default:
            return 0;
    }
}

                     
                     
@end
