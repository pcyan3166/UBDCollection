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

@interface YGYViewController () <UBDPageInfoProtocol>

@end

@implementation YGYViewController
@module(6)
@page(6)

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"sandbox path is %@", [NSBundle mainBundle].bundlePath);
    NSLog(@"current device is %@", [BasicTools deviceType]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UBDPageInfoProtocol functions

- (NSInteger)moduleId {
    return 0;
}

- (NSInteger)pageId {
    return 0;
}

@end
