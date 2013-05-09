//
//  CueSyncSet.m
//  TheKitchenSync
//
//  Created by Aaron Sarazan on 5/8/13.
//  Copyright (c) 2013 Cue. All rights reserved.
//

#import "CueSyncSet.h"
#import "CueSyncCollectionsPriv.h"
#import "CueReadWriteLock.h"

@implementation CueSyncSet {
    NSMutableSet *_set;
    CueReadWriteLock *_lock;
}


#pragma mark - Static Factory

+ (instancetype)from:(NSSet *)set;
{
    return [[[CueSyncSet alloc] initWithSet:set] autorelease];
}


#pragma mark - Init

- (id)init;
{
    return [self initWithSet:[NSSet set]];
}

- (id)initWithSet:(NSSet *)set;
{
    self = [super init];
    if (self) {
        _lock  = [[CueReadWriteLock alloc] init];
        _set = [set mutableCopy];
    }
    return self;
}

- (id)initWithArray:(NSArray *)array;
{
    return [self initWithSet:[NSSet setWithArray:array]];
}


#pragma mark - Query

- (BOOL)containsObject:(id)anObject;
{
    READ
    return [_set containsObject:anObject];
}

- (NSUInteger)count;
{
    READ
    return [_set count];
}

- (id)anyObject;
{
    READ
    return [_set anyObject];
}

- (NSArray *)allObjects;
{
    READ
    return [_set allObjects];
}

- (NSString *)description;
{
    READ
    return [_set description];
}


#pragma mark - Add

- (void)addObject:(id)object;
{
    WRITE
    [_set addObject:object];
}

- (void)addObjectsFromArray:(NSArray *)array;
{
    WRITE
    [_set addObjectsFromArray:array];
}


#pragma mark - Remove

- (void)removeObject:(id)object;
{
    WRITE
    [_set removeObject:object];
}

- (void)removeAllObjects;
{
    WRITE
    [_set removeAllObjects];
}


#pragma mark - Filter and Sort

- (CueSyncSet *)filteredSetUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;
{
    READ
    return [[_set filteredSetUsingPredicate:[NSPredicate predicateWithBlock:block]] cueConcurrent];
}

- (void)filterUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;
{
    WRITE
    [_set filterUsingPredicate:[NSPredicate predicateWithBlock:block]];
}

- (CueSyncArray *)sortedArrayUsingDescriptors:(NSArray *)sortDescriptors;
{
    READ
    return [[_set sortedArrayUsingDescriptors:sortDescriptors] cueConcurrent];
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

- (NSMutableSet *)unsafeSet;
{
    return _set;
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    NSSet *set = [aDecoder decodeObjectForKey:@"set"];
    return [self initWithSet:set];
}

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    READ
    [aCoder encodeObject:_set forKey:@"set"];
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
    return [retval initWithSet:_set];
}

- (BOOL)isEqual:(id)object;
{
    if (object == self) {
        return YES;
    }
    READ
    if ([object isKindOfClass:[CueSyncSet class]]) {
        CueSyncSet *other = object;
        id lock = other->_lock;
        CueStackLock(lock);
        return [_set isEqual:other->_set];
    }
    return NO;
}

// We don't want it to hash the same as an NSArray
// because we can't reliably do the right thing
// with isEqual, so we offset by one.
- (NSUInteger)hash;
{
    READ
    return _set.hash + 1;
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id *)stackbuf
                                    count:(NSUInteger)len;
{
    READ
    NSSet *safeCopy = [[_set copy] autorelease];
    return [safeCopy countByEnumeratingWithState:state objects:stackbuf count:len];
}

- (void)dealloc;
{
    [_set release];
    [_lock release];
    [super dealloc];
}
@end
