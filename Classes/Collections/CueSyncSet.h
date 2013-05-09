//
//  CueSyncSet.h
//  TheKitchenSync
//
//  Created by Aaron Sarazan on 5/8/13.
//  Copyright (c) 2013 Cue. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CueSyncArray;

/**
 * A thread-safe set object composed of
 * an NSMutableSet and a CueReadWriteLock.
 */
@interface CueSyncSet : NSObject
<NSFastEnumeration, NSCoding, NSCopying, NSMutableCopying, NSLocking>


#pragma mark - Static Factory

+ (instancetype)from:(NSSet *)set;


#pragma mark - Init

- (id)init;

- (id)initWithSet:(NSSet *)set;

- (id)initWithArray:(NSArray *)array;


#pragma mark - Query

- (BOOL)containsObject:(id)anObject;

- (NSUInteger)count;

- (id)anyObject;

- (NSArray *)allObjects;


#pragma mark - Add

- (void)addObject:(id)object;

- (void)addObjectsFromArray:(NSArray *)array;


#pragma mark - Remove

- (void)removeObject:(id)object;

- (void)removeAllObjects;


#pragma mark - Filter and Sort

- (CueSyncSet *)filteredSetUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;

- (void)filterUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;

- (CueSyncArray *)sortedArrayUsingDescriptors:(NSArray *)sortDescriptors;


#pragma mark - Locking

- (void)lockForRead;

- (void)lockForWrite;


#pragma mark - Unsafe

- (NSMutableSet *)unsafeSet;

@end
