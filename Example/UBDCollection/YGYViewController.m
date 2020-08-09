//
//  YGYViewController.m
//  UBDCollection
//
//  Created by pcyan on 07/18/2020.
//  Copyright (c) 2020 pcyan. All rights reserved.
//

#import "YGYViewController.h"
#import <BasicTools/BasicTools+DeviceInfo.h>
#import <UBDCollection/UBDPageInfoProtocol.h>
#import <UBDCollection/UBDPageInfo.h>
#import <UBDCollection/UBDDatabaseService.h>
#import <UBDCollection/UBDEventItemService.h>
#import <UBDCollection/UBDEventItem.h>

@interface YGYViewController () <UBDPageInfoProtocol>

@end

@implementation YGYViewController
@DEF_MODULE_ID(6)
@DEF_PAGE_ID(6)

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"sandbox path is %@", [NSBundle mainBundle].bundlePath);
    NSLog(@"current device is %@", [BasicTools deviceType]);
    
    NSLog(@"current moduleId is %ld", [self _ubd_module_id_]);
    NSLog(@"current moduleId is %ld", [self _ubd_page_id_]);
    
    [UBDDatabaseService shareInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UBDEventItem * item = [[UBDEventItem alloc] init];
    item.moduleId = 1;
    item.pageId = 1;
    item.eventType = eEnterPageEvent;
    item.eventId = 1;
    item.pLevel = 1;
    item.ts = [[NSDate date] timeIntervalSince1970] * 1000;
    [UBDEventItemService addEvent:item];
}

#pragma mark - UBDPageInfoProtocol functions

- (NSInteger)moduleId {
    return 8;
}

- (NSInteger)pageId {
    return 9;
}

@end
