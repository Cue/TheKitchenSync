//
//  CueSyncSet.m
//  TheKitchenSync
//
//  Created by Aaron Sarazan on 5/8/13.
//  Copyright (c) 2013 Cue. All rights reserved.
//

#import "CueSyncSet.h"
#import "CueSyncCollectionsPriv.h"

@implementation CueSyncSet {
    NSMutableSet *_set;
    dispatch_queue_t _queue;
}


#pragma mark - Static Factory

+ (instancetype)from:(NSSet *)set;
{
    return [[[CueSyncSet alloc] initWithSet:set] autorelease];
}

+ (instancetype)fromArray:(NSArray *)array;
{
    return [[[CueSyncSet alloc] initWithArray:array] autorelease];
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
        _set = [set mutableCopy];
        _queue = dispatch_queue_create("com.cueup.CueSyncSet", DISPATCH_QUEUE_CONCURRENT);
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
    READ_TYPE(BOOL, [_set containsObject:anObject]);
}

- (NSUInteger)count;
{
    READ_TYPE(NSUInteger, [_set count]);
}

- (id)anyObject;
{
    READ_ID(_set.anyObject);
}

- (NSArray *)allObjects;
{
    READ_ID(_set.allObjects);
}

- (NSString *)description;
{
    READ_ID(_set.description);
}


#pragma mark - Add

- (void)addObject:(id)object;
{
    WRITE([_set addObject:object]);
}

- (void)addObjectsFromArray:(NSArray *)array;
{
    WRITE([_set addObjectsFromArray:array]);
}


#pragma mark - Remove

- (void)removeObject:(id)object;
{
    WRITE([_set removeObject:object]);
}

- (void)removeAllObjects;
{
    WRITE([_set removeAllObjects]);
}


#pragma mark - Filter and Sort

- (CueSyncSet *)filteredSetUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;
{
    READ_ID([[_set filteredSetUsingPredicate:[NSPredicate predicateWithBlock:block]] cueConcurrent]);
}

- (void)filterUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;
{
    WRITE([_set filterUsingPredicate:[NSPredicate predicateWithBlock:block]]);
}

- (CueSyncArray *)sortedArrayUsingDescriptors:(NSArray *)sortDescriptors;
{
    READ_ID([[_set sortedArrayUsingDescriptors:sortDescriptors] cueConcurrent]);
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
    READ([aCoder encodeObject:_set forKey:@"set"]);
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone;
{
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone;
{
    READ_ID([[self.class allocWithZone:zone] initWithSet:_set]);
}

- (void)withSet:(void (^)(NSSet *set))block;
{
    READ(if (block) { block(_set); });
}

- (BOOL)isEqual:(id)object;
{
    if (object == self) {
        return YES;
    }
    if ([object isKindOfClass:[CueSyncSet class]]) {
        CueSyncSet *other = object;
        __block BOOL retval = NO;
        [other withSet:^(NSSet *set) {
            [self withSet:^(NSSet *set_) {
                retval = [set isEqual:set_];
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
    READ_TYPE(NSUInteger, _set.hash + 1);
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id *)stackbuf
                                    count:(NSUInteger)len;
{
    READ_TYPE(NSUInteger, [[[_set copy] autorelease] countByEnumeratingWithState:state objects:stackbuf count:len]);
}

- (void)dealloc;
{
    [_set release];
    dispatch_release(_queue);
    [super dealloc];
}
@end
