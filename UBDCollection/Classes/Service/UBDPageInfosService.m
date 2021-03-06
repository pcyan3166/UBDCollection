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

+ (instancetype)shareInstanceWithFilePath:(NSString * _Nullable)loadFilePath {
    static UBDPageInfosService *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[UBDPageInfosService alloc] init];
        [sInstance loadDataFromFile:loadFilePath];
    });
    
    return sInstance;
}

+ (NSString *)filePathForTesting {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"UBDCollection" ofType:@"bundle"];
    bundle = [NSBundle bundleWithPath:bundlePath];
    return [bundle pathForResource:@"UBDPageInfos" ofType:@"plist"];
}

- (void)checkForUpdateWithRemoteUrl:(NSString *)urlPath {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (urlPath.length > 0) {
            NSURL *URL = [NSURL URLWithString:urlPath];
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfURL:URL];
            if (dic != nil && [dic isKindOfClass:[NSDictionary class]] && dic.count > 0) {
                NSNumber *versionNum = dic[@"version"];
                NSNumber *localVersionNum = weakSelf.pageInfoDic[@"version"];
                if (versionNum != nil && [versionNum isKindOfClass:[NSNumber class]] &&
                    localVersionNum != nil && [localVersionNum isKindOfClass:[NSNumber class]]) {
                    NSInteger version = [versionNum integerValue];
                    NSInteger localVersion = [localVersionNum integerValue];
                    if (version > localVersion) {
                        weakSelf.pageInfoDic = dic;
                    }
                } else {
                    NSLog(@"远端或本地配置文件version缺失");
                }
            }
        }
    });
}

- (UBDPageInfoItem *)pageInfoForPageInstance:(id)pInstance {
    return [self pageInfoForPageClass:[pInstance class]];
}

- (UBDPageInfoItem *)pageInfoForPageClass:(Class)pClass {
    return [self pageInfoForPageClassName:NSStringFromClass(pClass)];
}

- (UBDPageInfoItem *)pageInfoForPageClassName:(NSString *)pClassName {
    if (pClassName != nil) {
        NSDictionary *pageItemDic = _pageInfoDic[pClassName];
        if (pageItemDic != nil) {
            UBDPageInfoItem *item = [[UBDPageInfoItem alloc] init];
            item.moduleId = [pageItemDic[@"moduleId"] integerValue];
            item.pageId = [pageItemDic[@"pageId"] integerValue];
            
            return item;
        }
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
        
        NSDictionary *dic = @{@"moduleId":@(pageInfo.moduleId), @"pageId":@(pageInfo.pageId)};
        mDic[pClassName] = dic;
        
        @synchronized (_pageInfoDic) {
            _pageInfoDic = mDic;
        }
        
        [self efficientlySavePageInfo];
        return YES;
    }
    
    return NO;
}

#pragma mark - private functions

- (void)loadDataFromFile:(NSString *)filePath {
    if (filePath.length <= 0) {
        _pageInfoFilePath = [self aValidPathForWritten];
        _pageInfoDic = [NSDictionary dictionaryWithContentsOfFile:_pageInfoFilePath];
    } else {
        _pageInfoDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        if ([self isValidPathForWritten:filePath]) {
            _pageInfoFilePath = [filePath copy];
        } else {
            _pageInfoFilePath = [self aValidPathForWritten];
        }
    }
}

- (void)savePageInfoIntoFile:(NSString *)filePath {
    if (filePath.length > 0) {
        [_pageInfoDic writeToFile:filePath atomically:YES];
    }
}

- (void)efficientlySavePageInfo {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(savePageInfoIntoFile:)
                                               object:_pageInfoFilePath];
    
    // 3秒延时存储，避免大量调用多次无效写入
    [self performSelector:@selector(savePageInfoIntoFile:) withObject:_pageInfoFilePath afterDelay:3.0];
}

- (BOOL)isValidPathForWritten:(NSString *)filePath {
    NSString *mainBundlePath = [NSBundle mainBundle].bundlePath;
    
    // 如果路径在mainBundle下，肯定不可写，那换个可写的地方
    if ([filePath hasPrefix:mainBundlePath]) {
        return NO;
    }
    
    return YES;
}

- (NSString *)aValidPathForWritten {
    NSArray *documentpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentRootPath = documentpaths[0];
    return [documentRootPath stringByAppendingPathComponent:@"UBDCollection/UBDPageInfos.plist"];
}

@end
