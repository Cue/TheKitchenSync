//
//  CueConcurrentArray.h
//  CueCore
//
//  Created by Aaron Sarazan on 5/4/13.
//  Copyright (c) 2013 Cue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A concurrent array object composed of
 * an NSMutableArray and a CueReadWriteLock.
 */
@interface CueConcurrentArray : NSObject
<NSFastEnumeration, NSCoding, NSCopying, NSMutableCopying>

#pragma mark - Static Factory

+ (instancetype)from:(NSArray *)array;

#pragma mark - Init

- (id)init;

- (id)initWithArray:(NSArray *)array;

#pragma mark - Query

- (BOOL)containsObject:(id)anObject;

- (NSUInteger)indexOfObject:(id)anObject;

- (NSUInteger)count;

- (id)objectAtIndex:(NSUInteger)index;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

#pragma mark - Add

- (void)addObject:(id)object;

- (void)addObjectsFromArray:(NSArray *)array;

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

#pragma mark - Remove

- (void)removeObject:(id)object;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)removeLastObject;

- (void)removeAllObjects;

#pragma mark - Unsafe

- (NSMutableArray *)unsafeArray;

@end
