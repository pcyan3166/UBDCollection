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

+ (void)addEvent:(UBDEventItem *)item {
    NSString *sql = [NSString stringWithFormat:@"insert into t_events \
                     (moduleId, pageId, eventId, eventType, pLevel, extraInfo, sendStatus, realTime, ts) values \
                     (%ld, %ld, %ld, %d, %ld, %@, %lu, %d, %ld)",
                     item.moduleId, item.pageId, item.eventId, item.eventType, item.pLevel,
                     item.extraInfo ? item.extraInfo : @"''", item.sendStatus, item.realTime, item.ts];
    [[UBDDatabaseService shareInstance].databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:sql];
    }];
}

+ (void)addEvent:(UBDEventItem *)item withResult:(AddEventsDataResultBlock)result {
    NSString *sql = [NSString stringWithFormat:@"insert into t_events \
                     (moduleId, pageId, eventId, eventType, pLevel, extraInfo, sendStatus, realTime, ts) values \
                     (%ld, %ld, %ld, %d, %ld, %@, %lu, %d, %ld)",
                     item.moduleId, item.pageId, item.eventId, item.eventType, item.pLevel,
                     item.extraInfo ? item.extraInfo : @"''", item.sendStatus, item.realTime, item.ts];
    [[UBDDatabaseService shareInstance].databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:sql];
        
        FMResultSet *set = [db executeQuery:@"select eId from t_events where rowid = last_insert_rowid()"];
        if ([set next]) {
            item.eId = [set intForColumnIndex:0];
            if (result) {
                result(item);
            }
        } else {
            if (result) {
                result(item);
            }
        }
    }];
}

+ (void)removeEventWithId:(NSInteger)eId {
    NSString *sql = [NSString stringWithFormat:@"delete from t_events where eId = %ld", eId];
    [[UBDDatabaseService shareInstance].databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:sql];
    }];
}

+ (void)removeEventsWithRequestId:(NSInteger)rId {
    if (rId > 0) {
        NSString *sql = [NSString stringWithFormat:@"delete from t_events where rId = %ld", rId];
        [[UBDDatabaseService shareInstance].databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            [db executeUpdate:sql];
        }];
    }
}

+ (void)clearEvents {
    NSString *sql = @"delete from t_events";
    [[UBDDatabaseService shareInstance].databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:sql];
    }];
}

+ (void)updateRequestId:(NSInteger)rId forEvents:(NSArray<UBDEventItem *> *)events {
    [[UBDDatabaseService shareInstance].databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        for (UBDEventItem *item in events) {
            NSString *sql = [NSString stringWithFormat:@"update t_events set rId = %ld where eId = %ld",
                             rId, item.eId];
            [db executeUpdate:sql];
        }
    }];
}

+ (void)updateSendStatus:(ESendStatus)fromStatus
                toStatus:(ESendStatus)toStatus
               forEvents:(NSArray<UBDEventItem *> * _Nullable)events {
    [[UBDDatabaseService shareInstance].databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        if (events == nil) {
            NSString *sql = [NSString stringWithFormat:@"update t_events set sendStatus = %lu where sendStatus = %lu",
                             toStatus, fromStatus];
            [db executeUpdate:sql];
        } else {
            for (UBDEventItem *item in events) {
                NSString *sql = [NSString stringWithFormat:@"update t_events set sendStatus = %lu where eId = %ld",
                                 toStatus, item.eId];
                [db executeUpdate:sql];
            }
        }
    }];
}

+ (void)getPreviousPageEventsWithPartitionEventId:(NSInteger)eId
                                        descOrder:(BOOL)isDesc
                                     andPageCount:(NSUInteger)count
                                   andResultBlock:(GetEventsDataResultBlock)resultBlock {
    NSString *sql = [NSString stringWithFormat:@"select * from t_events order by eId %@ limit %lu",
                     isDesc ? @"desc" : @"asc", count + 1];
    if (eId > 0) {
        if (isDesc) {
            sql = [NSString stringWithFormat:@"select * from t_events where eId > %ld order by eId %@ limit %lu",
                   eId, isDesc ? @"desc" : @"asc", count + 1];
        } else {
            sql = [NSString stringWithFormat:@"select * from t_events where eId < %ld order by eId %@ limit %lu",
                   eId, isDesc ? @"desc" : @"asc", count + 1];
        }
    }
    
    [UBDEventItemService getEventsDataWithSql:sql withCount:count andResultBlock:resultBlock withRemoveFlag:YES];
}

+ (void)getNextPageEventsWithPartitionEventId:(NSInteger)eId
                                    descOrder:(BOOL)isDesc
                                 andPageCount:(NSUInteger)count
                               andResultBlock:(GetEventsDataResultBlock)resultBlock {
    NSString *sql = [NSString stringWithFormat:@"select * from t_events order by eId %@ limit %lu",
                     isDesc ? @"desc" : @"asc", count + 1];
    if (eId > 0) {
        if (isDesc) {
            sql = [NSString stringWithFormat:@"select * from t_events where eId < %ld order by eId %@ limit %lu",
                   eId, isDesc ? @"desc" : @"asc", count + 1];
        } else {
            sql = [NSString stringWithFormat:@"select * from t_events where eId > %ld order by eId %@ limit %lu",
                   eId, isDesc ? @"desc" : @"asc", count + 1];
        }
    }
    
    [UBDEventItemService getEventsDataWithSql:sql withCount:count andResultBlock:resultBlock withRemoveFlag:NO];
}

+ (void)getEventsDataWithSql:(NSString *)sql
                   withCount:(NSUInteger)count
              andResultBlock:(GetEventsDataResultBlock)resultBlock
              withRemoveFlag:(BOOL)removeHeader{
    [[UBDDatabaseService shareInstance].databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:sql];
        
        NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:count];
        while ([rs next]) {
            UBDEventItem *item = [UBDEventItemService getEventItemFromResultSet:rs];
            if (item != nil) {
                [mArray addObject:item];
            }
        }
        
        if (resultBlock) {
            BOOL hasMore = NO;
            if (mArray.count > count) {
                hasMore = YES;
                if (removeHeader) {
                    [mArray removeObjectAtIndex:0];
                } else {
                    [mArray removeLastObject];
                }
            }
            
            resultBlock(mArray, hasMore);
        }
    }];
}

+ (UBDEventItem *)getEventItemFromResultSet:(FMResultSet *)rs {
    if (rs == nil) {
        return nil;
    }
    
    UBDEventItem *eventItem = [[UBDEventItem alloc] init];
    eventItem.eId = [rs intForColumn:@"eId"];
    eventItem.ts = [rs longLongIntForColumn:@"ts"];
    eventItem.moduleId = [rs intForColumn:@"moduleId"];
    eventItem.pageId = [rs intForColumn:@"pageId"];
    eventItem.pLevel = [rs intForColumn:@"pLevel"];
    eventItem.eventId = [rs intForColumn:@"eventId"];
    eventItem.eventType = [rs intForColumn:@"eventType"];
    eventItem.extraInfo = [rs stringForColumn:@"extraInfo"];
    eventItem.sendStatus = [rs intForColumn:@"sendStatus"];
    eventItem.realTime = [rs boolForColumn:@"realTime"];
    eventItem.rId = [rs intForColumn:@"rId"];
    
    return eventItem;
}

@end
