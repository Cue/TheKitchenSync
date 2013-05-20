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
    dispatch_queue_t _queue;
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
        _queue = dispatch_queue_create("com.cueup.CueSyncDictionary", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma mark - Query

- (NSUInteger)count;
{
    READ_TYPE(NSUInteger, _dict.count);
}

- (NSArray *)allKeys;
{
    READ_ID(_dict.allKeys);
}

- (NSArray *)allValues;
{
    READ_ID(_dict.allValues);
}

- (id)objectForKey:(id)aKey;
{
    READ_ID([[[_dict objectForKey:aKey] retain] autorelease]);
}

- (id)objectForKeyedSubscript:(id)key;
{
    READ_ID([[[_dict objectForKeyedSubscript:key] retain] autorelease]);
}

- (NSString *)description;
{
    READ_ID(_dict.description);
}


#pragma mark - Add

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
{
    WRITE([_dict setObject:anObject forKey:aKey]);
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)aKey;
{
    WRITE([_dict setObject:object forKeyedSubscript:aKey]);
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;
{
    WRITE([_dict addEntriesFromDictionary:otherDictionary]);
}

- (void)setDictionary:(NSDictionary *)otherDictionary;
{
    WRITE([_dict setDictionary:otherDictionary]);
}


#pragma mark - Remove

- (void)removeObjectForKey:(id)aKey;
{
    WRITE([_dict removeObjectForKey:aKey]);
}

- (void)removeAllObjects;
{
    WRITE([_dict removeAllObjects]);
}


#pragma mark - Unsafe

- (NSMutableDictionary *)unsafeDictionary;
{
    return _dict;
}

- (NSDictionary *)dictionary;
{
    READ_ID([[_dict copy] autorelease]);
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    id dict = [aDecoder decodeObjectForKey:@"dict"];
    return [self initWithDictionary:dict];
}

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    READ([aCoder encodeObject:_dict forKey:@"dict"]);
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone;
{
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone;
{
    READ_ID([[self.class allocWithZone:zone] initWithDictionary:_dict]);
}

- (void)withDictionary:(void (^)(NSDictionary *dictionary))block;
{
    READ(if (block) { block(_dict); });
}

- (BOOL)isEqual:(id)object;
{
    if (object == self) {
        return YES;
    }
    if ([object isKindOfClass:[CueSyncDictionary class]]) {
        CueSyncDictionary *other = object;
        __block BOOL retval = NO;
        [other withDictionary:^(NSDictionary *dictionary) {
            [self withDictionary:^(NSDictionary *dictionary_) {
                retval = [dictionary isEqual:dictionary_];
            }];
        }];
        return retval;
    }
    return NO;
}

// We don't want it to hash the same as an NSDictionary
// because we can't reliably do the right thing
// with isEqual, so we offset by one.
- (NSUInteger)hash;
{
    READ_TYPE(NSUInteger, _dict.hash + 1);
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id *)stackbuf
                                    count:(NSUInteger)len;
{
    READ_TYPE(NSUInteger, [[[_dict copy] autorelease] countByEnumeratingWithState:state objects:stackbuf count:len]);
}

- (void)dealloc;
{
    [_dict release];
    dispatch_release(_queue);
    [super dealloc];
}

@end
