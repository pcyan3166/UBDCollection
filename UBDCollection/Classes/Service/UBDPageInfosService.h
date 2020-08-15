//
//  UBDPageInfosService.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UBDPageInfoItem;

/// 维护页面信息的服务
@interface UBDPageInfosService : NSObject

/// 单例对象
+ (instancetype)shareInstanceWithFilePath:(NSString * _Nullable)localFilePath;

/// 用于测试的配置文件
+ (NSString *)filePathForTesting;

/// 从网络上获取新配置
/// @param urlPath 网络上这个配置文件的url
- (void)checkForUpdateWithRemoteUrl:(NSString *)urlPath;

/// 获取某个页面对象的页面信息
/// @param pInstance 页面对象
- (UBDPageInfoItem *)pageInfoForPageInstance:(id)pInstance;

/// 获取某个页面对象的页面信息
/// @param pClass 页面对象的class
- (UBDPageInfoItem *)pageInfoForPageClass:(Class)pClass;

/// 获取某个页面对象的页面信息
/// @param pClassName 页面对象的名称
- (UBDPageInfoItem *)pageInfoForPageClassName:(NSString *)pClassName;

/// 设置页面对象的页面信息
/// @param pageInfo 页面信息
/// @param instance 页面对象
- (BOOL)setPageInfo:(UBDPageInfoItem *)pageInfo forPageInstance:(id)instance;

/// 设置页面对象的页面信息
/// @param pageInfo 页面信息
/// @param pClass 页面对象的class
- (BOOL)setPageInfo:(UBDPageInfoItem *)pageInfo forForPageClass:(Class)pClass;

/// 设置页面对象的页面信息
/// @param pageInfo 页面信息
/// @param pClassName 页面对象的名称
- (BOOL)setPageInfo:(UBDPageInfoItem *)pageInfo forForPageClassName:(NSString *)pClassName;

/// 真实存储的页面信息的文件路径
@property (nonatomic, strong, readonly) NSString *pageInfoFilePath;

@end

NS_ASSUME_NONNULL_END
