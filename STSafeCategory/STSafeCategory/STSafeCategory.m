//
//  STSafeCategory.m
//  STSafeCategory
//
//  Created by Sola on 16/8/9.
//  Copyright © 2016年 tscc-sola. All rights reserved.
//

#import "STSafeCategory.h"
#import <objc/runtime.h>

@implementation NSArray (STSafeCategory)

- (id)st_safeObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self st_safeObjectAtIndex:index];
    }
    return nil;
}

- (id)st_safeInitWithObjects:(const id [])objects count:(NSUInteger)count
{
    if (!objects) {
        return nil;
    }
    
    for (int i = 0; i < count; i++) {
        if(objects[i] == nil)
            return nil;
    }
    
    return [self st_safeInitWithObjects:objects count:count];
}

@end

@implementation NSMutableArray (STSafeCategory)

- (void)st_safeAddObject:(id)anObject
{
    if (anObject != nil) {
        [self st_safeAddObject:anObject];
    }
}

@end

@implementation NSDictionary (STSafeCategory)

- (id)st_safeObjectForKey:(id)aKey
{
    if(aKey == nil)
        return nil;
    id value = [self st_safeObjectForKey:aKey];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}


@end

@implementation NSMutableDictionary (STSafeCategory)

- (void)st_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject == nil || aKey == nil) {
        return;
    }
    
    [self st_safeSetObject:anObject forKey:aKey];
}

- (void)st_removeObjectForKey:(id)key {
    if (key) {
        [self st_removeObjectForKey:key];
    }
}

@end

@implementation NSURL (STSafeCategory)

+ (id)st_safeFileURLWithPath:(NSString *)path isDirectory:(BOOL)isDir
{
    if(path == nil) {
        return nil;
    }
    
    return [self st_safeFileURLWithPath:path isDirectory:isDir];
}

@end

@implementation NSFileManager (STSafeCategory)

-(NSDirectoryEnumerator *)st_safeEnumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *, NSError *))handler
{
    if(url == nil) {
        return nil;
    }
    
    return [self st_safeEnumeratorAtURL:url includingPropertiesForKeys:keys options:mask errorHandler:handler];
}

@end

@implementation STSafeCategory

+ (instancetype)sharedInstance {
    static STSafeCategory* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [STSafeCategory new];
    });
    return instance;
}

- (BOOL)swizzleMethod:(Class)cls originMethod:(SEL)originMethod withMethod:(SEL)newMethod
{
    Method origMethodTemp = class_getInstanceMethod(cls, originMethod);
    if (!origMethodTemp) {
        return NO;
    }
    
    Method newMethodTemp = class_getInstanceMethod(cls, newMethod);
    if (!newMethodTemp) {
        return NO;
    }
    
    class_addMethod(cls,
                    originMethod,
                    class_getMethodImplementation(cls, originMethod),
                    method_getTypeEncoding(origMethodTemp));
    class_addMethod(cls,
                    newMethod,
                    class_getMethodImplementation(cls, newMethod),
                    method_getTypeEncoding(newMethodTemp));
    
    method_exchangeImplementations(class_getInstanceMethod(cls, originMethod), class_getInstanceMethod(cls, newMethod));
    return YES;
}

- (BOOL)swizzleClassMethod:(Class)cls originMethod:(SEL)originMethod withMethod:(SEL)newMethod
{
    return [self swizzleMethod:object_getClass(cls) originMethod:originMethod withMethod:newMethod];
}

- (void)enableSafeCategory
{
    [self swizzleMethod:objc_getClass("__NSArrayI") originMethod:@selector(objectAtIndex:) withMethod:@selector(st_safeObjectAtIndex:)];
    
    [self swizzleMethod:objc_getClass("__NSPlaceholderArray") originMethod:@selector(initWithObjects:count:) withMethod:@selector(st_safeInitWithObjects:count:)];

    [self swizzleMethod:objc_getClass("__NSArrayM") originMethod:@selector(objectAtIndex:) withMethod:@selector(st_safeObjectAtIndex:)];

    [self swizzleMethod:objc_getClass("__NSArrayM") originMethod:@selector(addObject:) withMethod:@selector(st_safeAddObject:)];
    
    [self swizzleMethod:objc_getClass("__NSDictionaryI") originMethod:@selector(objectForKey:) withMethod:@selector(st_safeObjectForKey:)];
    
    [self swizzleMethod:objc_getClass("__NSDictionaryM") originMethod:@selector(objectForKey:) withMethod:@selector(st_safeObjectForKey:)];
    
    [self swizzleMethod:objc_getClass("__NSDictionaryM") originMethod:@selector(setObject:forKey:) withMethod:@selector(st_safeSetObject:forKey:)];
    
    [self swizzleMethod:objc_getClass("__NSDictionaryM") originMethod:@selector(removeObjectForKey:) withMethod:@selector(st_removeObjectForKey:)];

    [self swizzleClassMethod:[NSURL class] originMethod:@selector(fileURLWithPath:isDirectory:) withMethod:@selector(st_safeFileURLWithPath:isDirectory:)];
    
    [self swizzleMethod:[NSFileManager class] originMethod:@selector(enumeratorAtURL:includingPropertiesForKeys:options:errorHandler:) withMethod:@selector(st_safeEnumeratorAtURL:includingPropertiesForKeys:options:errorHandler:)];
}


@end
