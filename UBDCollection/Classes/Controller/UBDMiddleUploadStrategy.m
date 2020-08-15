//
//  UBDMiddleUploadStrategy.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/16.
//

#import "UBDMiddleUploadStrategy.h"

@implementation UBDMiddleUploadStrategy

- (instancetype)init {
    if (self = [super init]) {
        self.triggerEventsCountOnWifi = 10;
        self.uploadDelayAfterAppActiveOnWifi = 15;
        self.uploadTimeGapOnWifi = 15;
        self.uploadEventMaxCountPerTimeOnWifi = 20;
        self.uploadDelayTimeIfThereIsMoreDataOnWifi = 5;
        
        self.triggerEventsCountOnFastWWAN = 20;
        self.uploadDelayAfterAppActiveOnFastWWAN = 20;
        self.uploadTimeGapOnFastWWAN = 20;
        self.uploadEventMaxCountPerTimeOnFastWWAN = 10;
        self.uploadDelayTimeIfThereIsMoreDataOnFastWWAN = 4;
        
        self.triggerEventsCountOnSlowWWAN = 30;
        self.uploadDelayAfterAppActiveOnSlowWWAN = 30;
        self.uploadTimeGapOnSlowWWAN = 30;
        self.uploadEventMaxCountPerTimeOnSlowWWAN = 5;
        self.uploadDelayTimeIfThereIsMoreDataOnSlowWWAN = 3;
    }
    
    return self;
}

@end
