//
//  UBDDatabaseService.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/9.
//

#import "UBDDatabaseService.h"
#import <fmdb/FMDB.h>

@implementation UBDDatabaseService

+ (instancetype)shareInstance {
    static UBDDatabaseService *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[UBDDatabaseService alloc] init];
        [sInstance setupDB];
    });
    
    return sInstance;
}

- (void)setupDB {
    NSArray *documentpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentRootPath = documentpaths[0];
    
    NSString *ubdDirectory = [documentRootPath stringByAppendingPathComponent:@"UBDCollection"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:ubdDirectory isDirectory:NULL];
    if (!exist) {
        [fileManager createDirectoryAtPath:ubdDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    NSString *dbPath = [documentRootPath stringByAppendingPathComponent:@"UBDCollection/ubd.db"];
    _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    NSLog(@"dbPath is %@", dbPath);
    
    NSArray<NSString *> *createTableCmds = [self createTableCmds];
    [_databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        for (NSString *cmd in createTableCmds) {
            [db executeUpdate:cmd];
        }
    }];
}

- (NSArray<NSString *> *)createTableCmds {
    return @[
        @"CREATE TABLE IF NOT EXISTS t_events (             \
        eId INTEGER PRIMARY KEY AUTOINCREMENT,              \
        moduleId INTEGER NOT NULL,                          \
        pageId INTEGER NOT NULL,                            \
        eventId INTEGER NOT NULL,                           \
        eventType INT1 NOT NULL,                            \
        pLevel INTEGER NOT NULL,                            \
        extraInfo TEXT NULL DEFAULT '',                     \
        sendStatus INT1 NULL DEFAULT 0,                     \
        realTime INT1 NULL DEFAULT 0,                       \
        ts BIGINT NULL DEFAULT 0,                           \
        rId INTEGER NULL DEFAULT -1                         \
        )",
        
        @"CREATE TABLE IF NOT EXISTS t_events_packages (    \
        epId INTEGER PRIMARY KEY AUTOINCREMENT,             \
        appVersion TEXT NOT NULL,                           \
        osVersion TEXT NOT NULL,                            \
        networkType TEXT NOT NULL,                          \
        deviceId TEXT NOT NULL,                             \
        userId TEXT NULL DEFAULT '',                        \
        tags TEXT NULL DEFAULT '',                          \
        preTs BIGINT NULL DEFAULT 0,                        \
        curTs BIGINT NULL DEFAULT 0,                        \
        rId INTEGER NULL DEFAULT -1                         \
        )",
        
        @"CREATE TABLE IF NOT EXISTS t_requests (           \
        rId INTEGER PRIMARY KEY AUTOINCREMENT,              \
        reqTs BIGINT NOT NULL,                              \
        resTs BIGINT NULL DEFAULT 0,                        \
        success INT1 DEFAULT 0,                             \
        failReason TEXT NULL DEFAULT ''                     \
        )"
    ];
}

@end
