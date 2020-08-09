//
//  UBDEventItemService.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/3.
//

#import "UBDEventItemService.h"
#import "UBDDatabaseService.h"
#import "UBDEventItem.h"
#import <fmdb/FMDB.h>

@implementation UBDEventItemService

+ (instancetype)shareInstance {
    static UBDEventItemService *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[UBDEventItemService alloc] init];
    });
    
    return sInstance;
}

+ (void)addEvent:(UBDEventItem *)item {
    NSString *sql = [NSString stringWithFormat:@"insert into t_events \
                     (moduleId, pageId, eventId, eventType, pLevel, extraInfo, sendStatus, realTime, ts) values (%ld, %ld, %ld, %d, %ld, %@, %lu, %d, %ld)",
                     item.moduleId, item.pageId, item.eventId, item.eventType, item.pLevel,
                     item.extraInfo ? item.extraInfo : @"''", item.sendStatus, item.realTime, item.ts];
    [[UBDDatabaseService shareInstance].databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:sql];
        
        FMResultSet *set = [db executeQuery:@"select * from t_events where rowid = last_insert_rowid()"];
        if ([set next]) {
            item.eId = [set intForColumn:@"eId"];
        }
    }];
}

+ (void)removeEventWithId:(NSInteger)eId {
    //
}

+ (void)getEventsWithCount:(NSUInteger)count andResultBlock:(GetEventsDataResultBlock)resultBlock {
    //
}

+ (void)getEventsWithIds:(NSArray<NSNumber *> *)ids andResultBlock:(GetEventsDataResultBlock)resultBlock {
    //
}

+ (void)clearEvents {
    //
}

+ (void)getPreviousPageEventsWithPartitionEventId:(NSInteger)eId
                                     andPageCount:(NSUInteger)count
                                   andResultBlock:(GetEventsDataResultBlock)resultBlock {
    //
}

+ (void)getNextPageEventsWithPartitionEventId:(NSInteger)eId
                                 andPageCount:(NSUInteger)count
                               andResultBlock:(GetEventsDataResultBlock)resultBlock {
    //
}

@end
