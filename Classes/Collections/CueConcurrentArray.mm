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

#import "CueConcurrentArray.h"
#import "CueConcurrentCollectionsPriv.h"
#import "CueReadWriteLock.h"

@implementation CueConcurrentArray {
    NSMutableArray *_array;
    CueReadWriteLock *_lock;
}


#pragma mark - Static Factory

+ (instancetype)from:(NSArray *)array;
{
    return [[[self alloc] initWithArray:array] autorelease];
}


#pragma mark - Init

- (id)init;
{
    return [self initWithArray:@[]];
}

- (id)initWithArray:(NSArray *)array;
{
    self = [super init];
    if (self) {
        _lock = [[CueReadWriteLock alloc] init];
        _array = [array mutableCopy];
    }
    return self;
}


#pragma mark - Query

- (BOOL)containsObject:(id)anObject;
{
    READ
    return [_array containsObject:anObject];
}

- (NSUInteger)indexOfObject:(id)anObject;
{
    READ
    return [_array indexOfObject:anObject];
}

- (NSUInteger)count;
{
    READ
    return [_array count];
}

- (id)objectAtIndex:(NSUInteger)index;
{
    READ
    return [[[_array objectAtIndex:index] retain] autorelease];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
{
    READ
    return [[[_array objectAtIndexedSubscript:idx] retain] autorelease];
}


#pragma mark - Add

- (void)addObject:(id)object;
{
    WRITE
    [_array addObject:object];
}

- (void)addObjectsFromArray:(NSArray *)array;
{
    WRITE
    [_array addObjectsFromArray:array];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
{
    WRITE
    [_array insertObject:anObject atIndex:index];
}

- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index;
{
    WRITE
    [_array setObject:anObject atIndexedSubscript:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
{
    WRITE
    [_array replaceObjectAtIndex:index withObject:anObject];
}


#pragma mark - Remove

- (void)removeObject:(id)object;
{
    WRITE
    [_array removeObject:object];
}

- (void)removeObjectAtIndex:(NSUInteger)index;
{
    WRITE
    [_array removeObjectAtIndex:index];
}

- (void)removeLastObject;
{
    WRITE
    [_array removeLastObject];
}

- (void)removeAllObjects;
{
    WRITE
    [_array removeAllObjects];    
}


#pragma mark - Filter and Sort

- (CueConcurrentArray *)filteredArrayUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;
{
    READ
    return [[_array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:block]] cueConcurrent];
}

- (void)filterUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;
{
    WRITE
    [_array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:block]];
}

- (CueConcurrentArray *)sortedArrayUsingDescriptors:(NSArray *)sortDescriptors;
{
    READ
    return [[_array sortedArrayUsingDescriptors:sortDescriptors] cueConcurrent];
}

- (void)sortUsingDescriptors:(NSArray *)sortDescriptors;
{
    WRITE
    [_array sortUsingDescriptors:sortDescriptors];
}


#pragma mark - Locking

- (void)lock;
{
    [self lockForRead];
}

- (void)lockForRead;
{
    [_lock lockForRead];
}

- (void)lockForWrite;
{
    [_lock lockForWrite];
}

- (void)unlock;
{
    [_lock unlock];
}


#pragma mark - Unsafe

- (NSMutableArray *)unsafeArray;
{
    return _array;
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    NSArray *array = [aDecoder decodeObjectForKey:@"array"];
    return [self initWithArray:array];
}

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    READ
    [aCoder encodeObject:_array forKey:@"array"];
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
    return [retval initWithArray:_array];
}

- (BOOL)isEqual:(id)object;
{
    if (object == self) {
        return YES;
    }    
    READ
    if ([object isKindOfClass:[CueConcurrentArray class]]) {
        CueConcurrentArray *other = object;
        id lock = other->_lock;
        CueStackLock(lock);
        return [_array isEqual:other->_array];
    }    
    return NO;
}

// We don't want it to hash the same as an NSArray
// because we can't reliably do the right thing
// with isEqual, so we offset by one.
- (NSUInteger)hash;
{
    READ
    return _array.hash + 1;
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id *)stackbuf
                                    count:(NSUInteger)len;
{
    READ
    NSArray *safeCopy = [[_array copy] autorelease];
    return [safeCopy countByEnumeratingWithState:state objects:stackbuf count:len];
}

- (void)dealloc;
{
    [_array release];
    [_lock release];
    [super dealloc];
}

@end
