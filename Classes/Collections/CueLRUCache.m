/*
 * Copyright 2013 TheKitchenSync Authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>
#import "CueLRUCache.h"
#import "CueValueLoader.h"
#import "CueOrderedDictionary.h"


@implementation CueLRUCache {
    id (^_loader)(id);
    NSLock *_lock;
    uint32_t _size;
    CueOrderedDictionary *_cache;
}

- (id)initWithLoader:(id (^)(id))block
   isMemorySensitive:(BOOL)memorySensitive
                size:(uint32_t)size;
{
    if ((self = [super init])) {
        _size = size;
        _cache = [[CueOrderedDictionary alloc] init];
        _lock = [[NSLock alloc] init];
        
        if (memorySensitive) {
          [[NSNotificationCenter defaultCenter] addObserver:self
                                                   selector:@selector(memoryWarning)
                                                       name:UIApplicationDidReceiveMemoryWarningNotification
                                                     object:nil];
        }
        
        _loader = [block copy];
    }
    return self;
}

- (void)memoryWarning;
{
    [self removeAllObjects];
}

- (CueValueLoader *)loaderForKey:(id)key;
{
    [key retain];
    
    CueValueLoader *loader;
    
    [_lock lock];
    @synchronized (_cache) {
        loader = [[[_cache objectForKey:key] retain] autorelease];
        if (loader) {
            // Move the key/value pair to the back of the cache
            [_cache removeObjectForKey:key];
            [_cache setObject:loader forKey:key];
        } else {
            id (^loaderBlock)(id);
            loaderBlock = _loader;
            loader = [[[CueValueLoader alloc] initWithBlock:^id() {
                return loaderBlock ? loaderBlock(key) : nil;
            }] autorelease];
            [_cache setObject:loader forKey:key];
            if (_cache.count > _size) {
                [_cache removeFront];
            }
        }
    }
    [_lock unlock];
    
    [key release];
    return loader;
}

- (id)checkObjectForKey:(id)key;
{
    [key retain];
    CueValueLoader *loader;
    
    [_lock lock];
    loader = [[[_cache objectForKey:key] retain] autorelease];
    [_lock unlock];
    
    [key release];
    return [loader get];
}

- (id)objectForKey:(id)key;
{
    return [[self loaderForKey:key] get];
}

- (id)objectForKeyedSubscript:(id)key;
{
    return [self objectForKey:key];
}

- (void)setObject:(id)value forKey:(id)key;
{
    [[self loaderForKey:key] set:value];
}

- (void)removeObjectForKey:(id)key;
{
    [_lock lock];
    [_cache removeObjectForKey:key];
    [_lock unlock];
}

- (void)removeAllObjects;
{
    [_lock lock];
    [_cache removeAllObjects];
    [_lock unlock];
}

- (NSArray *)allKeys;
{
    return [_cache allKeys];
}

- (NSArray *)allValues;
{
    return [_cache allValues];
}

- (NSString *)description;
{
    return [_cache description];
}

- (NSDictionary *)dictionaryRepresentation;
{
    CueOrderedDictionary *retval = [CueOrderedDictionary dictionaryWithCapacity:_cache.count];
    for (id key in self.allKeys) {
        [retval setObject:[self objectForKey:key] forKey:key];
    }
    return retval;
}

- (void)dealloc;
{
    [_cache release];
    [_lock release];
    [_loader release];
    [super dealloc];
}

@end
