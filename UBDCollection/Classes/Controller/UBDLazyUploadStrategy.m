//
//  UBDLazyUploadStrategy.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/16.
//

#import "UBDLazyUploadStrategy.h"

@implementation UBDLazyUploadStrategy

- (instancetype)init {
    if (self = [super init]) {
        self.triggerEventsCountOnWifi = 20;
        self.uploadDelayAfterAppActiveOnWifi = 30;
        self.uploadTimeGapOnWifi = 30;
        self.uploadEventMaxCountPerTimeOnWifi = 20;
        self.uploadDelayTimeIfThereIsMoreDataOnWifi = 7;
        
        self.triggerEventsCountOnFastWWAN = 30;
        self.uploadDelayAfterAppActiveOnFastWWAN = 45;
        self.uploadTimeGapOnFastWWAN = 45;
        self.uploadEventMaxCountPerTimeOnFastWWAN = 10;
        self.uploadDelayTimeIfThereIsMoreDataOnFastWWAN = 6;
        
        self.triggerEventsCountOnSlowWWAN = 40;
        self.uploadDelayAfterAppActiveOnSlowWWAN = 60;
        self.uploadTimeGapOnSlowWWAN = 60;
        self.uploadEventMaxCountPerTimeOnSlowWWAN = 5;
        self.uploadDelayTimeIfThereIsMoreDataOnSlowWWAN = 5;
    }
    
    return self;
}

@end
