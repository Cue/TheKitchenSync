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

#import "CueLoadingCache.h"
#import "CueStackLock.h"
#import "CueValueLoader.h"
#import <UIKit/UIKit.h>

@implementation CueLoadingCache {
    NSMutableDictionary *_cache;
    NSLock *_lock;
    CueLoadingBlock _loader;
}

- (id)initWithLoader:(id (^)(id))block isMemorySensitive:(BOOL)memorySensitive;
{
    if ((self = [super init])) {
        _cache = [[NSMutableDictionary alloc] init];
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
    {
        CueStackLock(_lock);
        loader = [[[_cache objectForKey:key] retain] autorelease]; // Try once without a lock.
        if (!loader) {
            CueLoadingBlock block = _loader;
            loader = [[CueValueLoader alloc] initWithBlock:^id() {
                return block ? block(key) : nil;
            }];
            [_cache setObject:loader forKey:key];
            [loader release];
        }
    }
    [key release];
    return loader;
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
    CueStackLock(_lock);
    [_cache removeObjectForKey:key];
}

- (void)removeAllObjects;
{
    CueStackLock(_lock);
    [_cache removeAllObjects];
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

- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_cache release];
    [_lock release];
    [_loader release];
    [super dealloc];
}

@end
