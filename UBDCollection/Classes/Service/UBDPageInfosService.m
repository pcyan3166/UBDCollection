//
//  UBDPageInfosService.m
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/8.
//

#import "UBDPageInfosService.h"
#import "UBDPageInfoItem.h"

@interface UBDPageInfosService ()

@property (nonatomic, strong) NSDictionary *pageInfoDic;

@end

@implementation UBDPageInfosService

+ (instancetype)shareInstanceWithFilePath:(NSString *)localFilePath {
    static UBDPageInfosService *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[UBDPageInfosService alloc] init];
    });
    
    return sInstance;
}

- (void)checkForUpdate {
    //
}

- (UBDPageInfoItem *)pageInfoForPageInstance:(id)pInstance {
    return [self pageInfoForPageClass:[pInstance class]];
}

- (UBDPageInfoItem *)pageInfoForPageClass:(Class)pClass {
    return [self pageInfoForPageClassName:NSStringFromClass(pClass)];
}

- (UBDPageInfoItem *)pageInfoForPageClassName:(NSString *)pClassName {
    if (pClassName != nil) {
        return _pageInfoDic[pClassName];
    }
    
    return nil;
}

- (BOOL)setPageInfo:(UBDPageInfoItem *)pageInfo forPageInstance:(id)instance {
    return [self setPageInfo:pageInfo forForPageClass:[instance class]];
}

- (BOOL)setPageInfo:(UBDPageInfoItem *)pageInfo forForPageClass:(Class)pClass {
    return [self setPageInfo:pageInfo forForPageClassName:NSStringFromClass(pClass)];
}

- (BOOL)setPageInfo:(UBDPageInfoItem *)pageInfo forForPageClassName:(NSString *)pClassName {
    if (pageInfo != nil && pClassName != nil) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:_pageInfoDic];
        mDic[pClassName] = pageInfo;
        
        @synchronized (_pageInfoDic) {
            _pageInfoDic = mDic;
        }
    }
    
    return NO;
}

@end
