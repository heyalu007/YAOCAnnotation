//
//  YAAnnotationManager.m
//  YAOCAnnotationDemoTests
//
//  Created by 何亚鲁 on 2021/7/26.
//

#import "YAAnnotationManager.h"
#include <dlfcn.h>
#include <mach-o/getsect.h>

@interface YAAnnotationManager ()

@property (nonatomic, strong, readwrite) NSDictionary *classAnnotationDict;
@property (nonatomic, strong, readwrite) NSDictionary *methodAnnotationDict;

@end


@implementation YAAnnotationManager

+ (instancetype)sharedInstance {
    static YAAnnotationManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YAAnnotationManager alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.methodAnnotationDict = [self __readMethodInfoDataFromMachO];
        self.classAnnotationDict = [self __readClassInfoDataFromMachO];
    }
    return self;
}


#pragma mark - private method

- (NSDictionary *)__readMethodInfoDataFromMachO {
    //1.根据符号找到所在的mach-o文件信息
    Dl_info info;
    dladdr((__bridge void *)[self class], &info);
//    dladdr((__bridge void *)NSClassFromString(@"AnnotationTests"), &info);
    
    //2.读取__DATA中自定义的 MethodInfoData数据
    #ifndef __LP64__
        const struct mach_header *mhp = (struct mach_header*)info.dli_fbase;
        unsigned long schemeSize = 0;
        uint32_t *schemeMemory = (uint32_t*)getsectiondata(mhp, "__DATA", "MethodInfoData", &schemeSize);
    #else /* defined(__LP64__) */
        const struct mach_header_64 *mhp = (struct mach_header_64*)info.dli_fbase;
        unsigned long schemeSize = 0;
        uint64_t *schemeMemory = (uint64_t*)getsectiondata(mhp, "__DATA", "MethodInfoData", &schemeSize);
     
    #endif /* defined(__LP64__) */
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //3.遍历MethodInfoData中的协议数据
    unsigned long schemeCounter = schemeSize/sizeof(struct MethodInfo);
    struct MethodInfo *items = (struct MethodInfo*)schemeMemory;
    for (int idx = 0; idx < schemeCounter; ++idx) {
        NSString *classname = [NSString stringWithUTF8String:items[idx].classname];
        NSString *methodname = [NSString stringWithUTF8String:items[idx].methodname];
        NSString *desc = [NSString stringWithUTF8String:items[idx].desc];
        NSString *level = [NSString stringWithUTF8String:items[idx].level];
        NSLog(@"classname:%@ , methodname:%@ , desc:%@ , level:%@", classname, methodname, desc, level);
        if (!classname.length || !methodname.length) {
            continue;
        }
        
        NSMutableDictionary *classDict = [dict objectForKey:classname];
        if (classDict == nil) {
            classDict = [NSMutableDictionary dictionary];
            [dict setObject:classDict forKey:classname];
        }
        NSMutableDictionary *methodDict = [dict objectForKey:methodname];
        if (methodDict == nil) {
            methodDict = [NSMutableDictionary dictionary];
            [classDict setObject:methodDict forKey:methodname];
        }
        [methodDict setObject:desc forKey:@"desc"];
        [methodDict setObject:level forKey:@"level"];
    }
    
    return dict;
}

- (NSDictionary *)__readClassInfoDataFromMachO {
    //1.根据符号找到所在的mach-o文件信息
    Dl_info info;
    dladdr((__bridge void *)[self class], &info);
//    dladdr((__bridge void *)NSClassFromString(@"AnnotationTests"), &info);
    
    //2.读取__DATA中自定义的 ClassInfoData数据
    #ifndef __LP64__
        const struct mach_header *mhp = (struct mach_header*)info.dli_fbase;
        unsigned long schemeSize = 0;
        uint32_t *schemeMemory = (uint32_t*)getsectiondata(mhp, "__DATA", "ClassInfoData", &schemeSize);
    #else /* defined(__LP64__) */
        const struct mach_header_64 *mhp = (struct mach_header_64*)info.dli_fbase;
        unsigned long schemeSize = 0;
        uint64_t *schemeMemory = (uint64_t*)getsectiondata(mhp, "__DATA", "ClassInfoData", &schemeSize);
     
    #endif /* defined(__LP64__) */
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //3.遍历ClassInfoData中的协议数据
    unsigned long schemeCounter = schemeSize/sizeof(struct ClassInfo);
    struct ClassInfo *items = (struct ClassInfo*)schemeMemory;
    for (int idx = 0; idx < schemeCounter; ++idx) {
        NSString *classname = [NSString stringWithUTF8String:items[idx].classname];
        NSString *owner = [NSString stringWithUTF8String:items[idx].owner];
        NSString *interfacename = [NSString stringWithUTF8String:items[idx].interfacename];
        NSString *desc = [NSString stringWithUTF8String:items[idx].desc];
        NSString *level = [NSString stringWithUTF8String:items[idx].level];
        NSLog(@"classname:%@ , owner:%@ , interfacename:%@ , desc:%@ , level:%@", classname, owner, interfacename, desc, level);
        
        NSMutableDictionary *classDict = [dict objectForKey:classname];
        if (classDict == nil) {
            classDict = [NSMutableDictionary dictionary];
            [dict setObject:classDict forKey:classname];
        }
        [classDict setObject:owner forKey:@"owner"];
        [classDict setObject:interfacename forKey:@"interfacename"];
        [classDict setObject:desc forKey:@"desc"];
        [classDict setObject:level forKey:@"level"];
    }
    return dict;
}

@end
