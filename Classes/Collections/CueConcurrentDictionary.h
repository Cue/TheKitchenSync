//
//  CueConcurrentDictionary.h
//  CueConcurrency
//
//  Created by Aaron Sarazan on 5/4/13.
//  Copyright (c) 2013 Cue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A concurrent dictionary object composed of
 * an NSMutableDictionary and a CueReadWriteLock.
 */
@interface CueConcurrentDictionary : NSObject
<NSFastEnumeration, NSCoding, NSCopying, NSMutableCopying>


#pragma mark - Static Factory

+ (instancetype)from:(NSDictionary *)dictionary;


#pragma mark - Init

- (id)init;

- (id)initWithDictionary:(NSDictionary *)dictionary;


#pragma mark - Query

- (NSUInteger)count;

- (NSArray *)allKeys;

- (NSArray *)allValues;

- (id)objectForKey:(id)aKey;

- (id)objectForKeyedSubscript:(id)key;


#pragma mark - Add

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)aKey;

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;


#pragma mark - Remove

- (void)removeObjectForKey:(id)aKey;

- (void)removeAllObjects;


#pragma mark - Unsafe

- (NSMutableDictionary *)unsafeDictionary;


@end
