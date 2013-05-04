//
//  CueConcurrentArray.m
//  CueCore
//
//  Created by Aaron Sarazan on 5/4/13.
//  Copyright (c) 2013 Cue. All rights reserved.
//

#import "CueConcurrentArray.h"
#import "CueReadWriteLock.h"
#import "CueStackLock.h"

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


#define READ CueStackLock(_lock);
#define WRITE CueStackLockWrite(_lock);

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
    return [_array objectAtIndex:index];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
{
    READ
    return [_array objectAtIndexedSubscript:idx];
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
    READ
    return [_array copyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone;
{
    id retval = [self.class allocWithZone:zone];
    READ
    return [retval initWithArray:_array];
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
