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

#import "CueThreadLocal.h"

@interface CueThreadLocalKey : NSObject {
    int64_t _value;
}
@end

@implementation CueThreadLocalKey

- (id)initWithValue:(int64_t)value;
{
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (NSUInteger)hash;
{
    return (NSUInteger) (_value % NSUIntegerMax);
}

- (BOOL)isEqual:(id)object;
{
    return [object isMemberOfClass:[CueThreadLocalKey class]] && _value == ((CueThreadLocalKey *)object)->_value;
}

- (id)copyWithZone:(NSZone *)zone;
{
    return [[CueThreadLocalKey allocWithZone:zone] initWithValue:_value];
}

@end


@implementation CueThreadLocal {
    id _key;
}

- (id)init;
{
    if ((self = [super init])) {
        _key = [[CueThreadLocalKey alloc] initWithValue:(int64_t)self];
        [self remove]; // On the one in a million chance that we're reusing a key, clear the state.
    }
    return self;
}

- (void)dealloc;
{
    [_key release];
    [super dealloc];
}

- (id)get;
{
    return [[[NSThread currentThread] threadDictionary] objectForKey:_key];
}

- (void)set:(id)value;
{
    if (!value) {
        [self remove];
    } else {
        [[[NSThread currentThread] threadDictionary] setObject:value forKey:_key];
    }
}

- (void)remove;
{
    [[[NSThread currentThread] threadDictionary] removeObjectForKey:_key];
}

@end
