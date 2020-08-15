//
//  UBDRadicalUploadStrategy.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/16.
//

#import "UBDRadicalUploadStrategy.h"

@implementation UBDRadicalUploadStrategy

- (instancetype)init {
    if (self = [super init]) {
        self.triggerEventsCountOnWifi = 5;
        self.uploadDelayAfterAppActiveOnWifi = 10;
        self.uploadTimeGapOnWifi = 10;
        self.uploadEventMaxCountPerTimeOnWifi = 20;
        self.uploadDelayTimeIfThereIsMoreDataOnWifi = 3;
        
        self.triggerEventsCountOnFastWWAN = 8;
        self.uploadDelayAfterAppActiveOnFastWWAN = 15;
        self.uploadTimeGapOnFastWWAN = 15;
        self.uploadEventMaxCountPerTimeOnFastWWAN = 10;
        self.uploadDelayTimeIfThereIsMoreDataOnFastWWAN = 2;
        
        self.triggerEventsCountOnSlowWWAN = 10;
        self.uploadDelayAfterAppActiveOnSlowWWAN = 20;
        self.uploadTimeGapOnSlowWWAN = 20;
        self.uploadEventMaxCountPerTimeOnSlowWWAN = 5;
        self.uploadDelayTimeIfThereIsMoreDataOnSlowWWAN = 1;
    }
    
    return self;
}

@end
