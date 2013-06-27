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

#import "CueSyncArray.h"
#import "CueSyncCollectionsPriv.h"

@implementation CueSyncArray {
    NSMutableArray *_array;
    dispatch_queue_t _queue;
}


#pragma mark - Static Factory

+ (instancetype)from:(NSArray *)array;
{
    return [[[self alloc] initWithArray:array] autorelease];
}

+ (id)array;
{
    return [[[self alloc] init] autorelease];
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
        _array = array ? [array mutableCopy] : [@[] mutableCopy];
        _queue = dispatch_queue_create("com.cueup.CueSyncArray", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}


#pragma mark - Query

- (BOOL)containsObject:(id)anObject;
{
    READ_TYPE(BOOL, [_array containsObject:anObject]);
}

- (NSUInteger)indexOfObject:(id)anObject;
{
    READ_TYPE(NSUInteger, [_array indexOfObject:anObject]);
}

- (NSUInteger)count;
{
    READ_TYPE(NSUInteger, _array.count);
}

- (id)objectAtIndex:(NSUInteger)index;
{
    READ_ID([[[_array objectAtIndex:index] retain] autorelease]);
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
{
    READ_ID([[[_array objectAtIndexedSubscript:idx] retain] autorelease]);
}

- (NSString *)description;
{
    READ_ID(_array.description);
}


#pragma mark - Add

- (void)addObject:(id)object;
{
    WRITE([_array addObject:object]);
}

- (void)addObjectsFromArray:(NSArray *)array;
{
    WRITE([_array addObjectsFromArray:array]);
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
{
    WRITE([_array insertObject:anObject atIndex:index]);
}

- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index;
{
    WRITE([_array setObject:anObject atIndexedSubscript:index]);
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
{
    WRITE([_array replaceObjectAtIndex:index withObject:anObject]);
}

- (void)setArray:(NSArray *)otherArray;
{
    WRITE([_array setArray:otherArray]);
}


#pragma mark - Remove

- (void)removeObject:(id)object;
{
    WRITE([_array removeObject:object]);
}

- (void)removeObjectAtIndex:(NSUInteger)index;
{
    WRITE([_array removeObjectAtIndex:index]);
}

- (void)removeFirstInstanceOfObject:(id)object;
{
    WRITE(NSInteger index = [_array indexOfObject:object];
          if (index != NSNotFound) {
              [_array removeObjectAtIndex:index];
          });
}

- (void)removeLastObject;
{
    WRITE([_array removeLastObject]);
}

- (void)removeAllObjects;
{
    WRITE([_array removeAllObjects]);
}


#pragma mark - Filter and Sort

- (CueSyncArray *)filteredArrayUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;
{
    READ_ID([[_array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:block]] cueConcurrent]);
}

- (void)filterUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;
{
    WRITE([_array filterUsingPredicate:[NSPredicate predicateWithBlock:block]]);
}

- (CueSyncArray *)sortedArrayUsingDescriptors:(NSArray *)sortDescriptors;
{
    READ_ID([[_array sortedArrayUsingDescriptors:sortDescriptors] cueConcurrent]);
}

- (void)sortUsingDescriptors:(NSArray *)sortDescriptors;
{
    WRITE([_array sortUsingDescriptors:sortDescriptors]);
}


#pragma mark - Array

- (NSMutableArray *)unsafeArray;
{
    return _array;
}

- (NSArray *)array;
{
    READ_ID([[_array copy] autorelease]);
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    NSArray *array = [aDecoder decodeObjectForKey:@"array"];
    return [self initWithArray:array];
}

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    READ([aCoder encodeObject:_array forKey:@"array"]);
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone;
{
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone;
{
    READ_ID([[self.class allocWithZone:zone] initWithArray:_array]);
}

- (void)withArray:(void (^)(NSArray *array))block;
{
    READ(if (block) { block(_array); });
}

- (BOOL)isEqual:(id)object;
{
    if (object == self) {
        return YES;
    }
    if ([object isKindOfClass:[CueSyncArray class]]) {
        __block BOOL retval = NO;
        CueSyncArray *other = object;
        [other withArray:^(NSArray *array) {
            [self withArray:^(NSArray *array_) {
                retval = [array isEqual:array_];
            }];
        }];
        return retval;
    }    
    return NO;
}

// We don't want it to hash the same as an NSArray
// because we can't reliably do the right thing
// with isEqual, so we offset by one.
- (NSUInteger)hash;
{
    READ_TYPE(NSUInteger, _array.hash + 1);
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id *)stackbuf
                                    count:(NSUInteger)len;
{
    READ_TYPE(NSUInteger, [[[_array copy] autorelease] countByEnumeratingWithState:state objects:stackbuf count:len]);
}

- (void)dealloc;
{
    [_array release];
    dispatch_release(_queue);
    [super dealloc];
}

@end
