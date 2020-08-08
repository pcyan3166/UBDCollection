//
//  UBDPageInfo.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/8.
//

#ifndef UBDPageInfo_h
#define UBDPageInfo_h

#define DEF_MODULE_ID(_moduleId_)\
compatibility_alias _ModuleNSObject NSObject;\
- (NSInteger)_ubd_module_id_ {\
    SEL sel = NSSelectorFromString(@"moduleId");\
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:sel];\
    if (methodSignature != nil) {\
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];\
        [invocation setTarget:self];\
        [invocation setSelector:sel];\
        [invocation invoke];\
        NSInteger result;\
        if (methodSignature.methodReturnLength) {\
            [invocation getReturnValue:&result];\
            return result;\
        } else {\
            return _moduleId_;\
        }\
    }\
    return _moduleId_;\
}

#define DEF_PAGE_ID(_pageId_)\
compatibility_alias _PageNSObject NSObject;\
- (NSInteger)_ubd_page_id_ {\
    SEL sel = NSSelectorFromString(@"pageId");\
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:sel];\
    if (methodSignature != nil) {\
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];\
        [invocation setTarget:self];\
        [invocation setSelector:sel];\
        [invocation invoke];\
        NSInteger result;\
        if (methodSignature.methodReturnLength) {\
            [invocation getReturnValue:&result];\
            return result;\
        } else {\
            return _pageId_;\
        }\
    }\
    return _pageId_;\
}

#endif /* UBDPageInfo_h */
