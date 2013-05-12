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

#import "CueSyncDictionary.h"
#import "CueSyncCollectionsPriv.h"


@implementation CueSyncDictionary {
    NSMutableDictionary *_dict;
    std::mutex _lock;
}


#pragma mark - Static Factory

+ (instancetype)from:(NSDictionary *)dictionary;
{
    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}


#pragma mark - Init

- (id)init;
{
    return [self initWithDictionary:@{}];
}

- (id)initWithDictionary:(NSDictionary *)dictionary;
{
    self = [super init];
    if (self) {
        _dict = [dictionary mutableCopy];
    }
    return self;
}


#pragma mark - Query

- (NSUInteger)count;
{
    READ
    return _dict.count;
}

- (NSArray *)allKeys;
{
    READ
    return _dict.allKeys;
}

- (NSArray *)allValues;
{
    READ
    return _dict.allValues;
}

- (id)objectForKey:(id)aKey;
{
    READ
    return [[[_dict objectForKey:aKey] retain] autorelease];
}

- (id)objectForKeyedSubscript:(id)key;
{
    READ
    return [[[_dict objectForKeyedSubscript:key] retain] autorelease];
}

- (NSString *)description;
{
    READ
    return [_dict description];
}


#pragma mark - Add

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
{
    WRITE
    [_dict setObject:anObject forKey:aKey];
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)aKey;
{
    WRITE
    [_dict setObject:object forKeyedSubscript:aKey];
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;
{
    WRITE
    [_dict addEntriesFromDictionary:otherDictionary];
}


#pragma mark - Remove

- (void)removeObjectForKey:(id)aKey;
{
    WRITE
    [_dict removeObjectForKey:aKey];
}

- (void)removeAllObjects;
{
    WRITE
    [_dict removeAllObjects];
}


#pragma mark - Unsafe

- (NSMutableDictionary *)unsafeDictionary;
{
    return _dict;
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    id dict = [aDecoder decodeObjectForKey:@"dict"];
    return [self initWithDictionary:dict];
}

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    READ
    [aCoder encodeObject:_dict forKey:@"dict"];
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone;
{
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone;
{
    id retval = [self.class allocWithZone:zone];
    READ
    return [retval initWithDictionary:_dict];
}

- (BOOL)isEqual:(id)object;
{
    if (object == self) {
        return YES;
    }
    READ
    if ([object isKindOfClass:[CueSyncDictionary class]]) {
        CueSyncDictionary *other = object;
        std::mutex &lock = other->_lock;
        CueStackLockStd(lock);
        return [_dict isEqual:other->_dict];
    }
    return NO;
}

// We don't want it to hash the same as an NSDictionary
// because we can't reliably do the right thing
// with isEqual, so we offset by one.
- (NSUInteger)hash;
{
    READ
    return _dict.hash + 1;
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id *)stackbuf
                                    count:(NSUInteger)len;
{
    READ
    NSDictionary *safeCopy = [[_dict copy] autorelease];
    return [safeCopy countByEnumeratingWithState:state objects:stackbuf count:len];
}

- (void)dealloc;
{
    [_dict release];
    [super dealloc];
}

@end
