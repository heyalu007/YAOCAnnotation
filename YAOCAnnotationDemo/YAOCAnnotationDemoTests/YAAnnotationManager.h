//
//  YAAnnotationManager.h
//  YAOCAnnotationDemoTests
//
//  Created by 何亚鲁 on 2021/7/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct MethodInfo {
    char *classname;
    char *methodname;
    char *level;
    char *desc;
};

#define MethodAnnotation(_classname_,_methodname_,_level_,_desc_)\
__attribute__((used)) static struct MethodInfo MethodInfo##_classname_##_methodname_ \
__attribute__ ((used, section ("__DATA, MethodInfoData"))) =\
{\
    .classname = #_classname_,\
    .methodname = #_methodname_,\
    .level = #_level_,\
    .desc = #_desc_,\
};

struct ClassInfo {
    char *classname;
    char *owner;
    char *interfacename;
    char *level;
    char *desc;
};

#define ClassAnnotation(_classname_,_owner_,_interfacename_,_level_,_desc_)\
__attribute__((used)) static struct ClassInfo ClassInfo##_classname_ \
__attribute__ ((used, section ("__DATA, ClassInfoData"))) =\
{\
    .classname = #_classname_,\
    .owner = #_owner_,\
    .interfacename = #_interfacename_,\
    .level = #_level_,\
    .desc = #_desc_,\
};

@interface YAAnnotationManager : NSObject

@property (nonatomic, strong, readonly) NSDictionary *classAnnotationDict;
@property (nonatomic, strong, readonly) NSDictionary *methodAnnotationDict;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
