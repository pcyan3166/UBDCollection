//
//  UBDPageInfo.h
//  UBDCollection
//
//  Created by pengchao yan on 2020/8/8.
//

#ifndef UBDPageInfo_h
#define UBDPageInfo_h

#define module(_moduleId_)                                          \
compatibility_alias _SimpleDefinePageInfo SimpleDefinePageInfo;     \
- (NSInteger)_ubd_module_id_:(NSInteger)_moduleId_ {                \
    if ([self respondsToSelector:@selector(moduleId)]) {            \
        return [self moduleId];                                     \
    }                                                               \
    return _moduleId_;                                              \
}

#define page(_pageId_)                                              \
compatibility_alias _SimpleDefinePageInfo SimpleDefinePageInfo;     \
- (NSInteger)_ubd_page_id_:(NSInteger)_pageId_ {                    \
    if ([self respondsToSelector:@selector(pageId)]) {              \
        return [self pageId];                                       \
    }                                                               \
    return _pageId_;                                                \
}

#endif /* UBDPageInfo_h */
