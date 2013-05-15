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

#import <Foundation/Foundation.h>

@class CueSyncArray;


/**
 * Interface that CueSyncSet shares with NSMutableSet
 */
@protocol ICueSet <NSFastEnumeration, NSCoding, NSCopying, NSMutableCopying>
@required


#pragma mark - Query

- (BOOL)containsObject:(id)anObject;

- (NSUInteger)count;

- (id)anyObject;

- (NSArray *)allObjects;

@end
typedef NSObject<ICueSet> CueSet;


/**
 * Interface that CueSyncSet shares with NSMutableSet
 */
@protocol ICueMutableSet <ICueSet>
@required


#pragma mark - Add

- (void)addObject:(id)object;

- (void)addObjectsFromArray:(NSArray *)array;


#pragma mark - Remove

- (void)removeObject:(id)object;

- (void)removeAllObjects;

@end
typedef NSObject<ICueMutableSet> CueMutableSet;


/**
 * A thread-safe set object composed of
 * an NSMutableSet and a lock.
 *
 * Should only be iterated using fast-enumeration. i++ is not synchronized.
 */
@interface CueSyncSet : NSObject <ICueMutableSet>


#pragma mark - Static Factory

+ (instancetype)from:(NSSet *)set;

+ (instancetype)fromArray:(NSArray *)array;


#pragma mark - Init

- (id)init;

- (id)initWithSet:(NSSet *)set;

- (id)initWithArray:(NSArray *)array;


#pragma mark - Filter and Sort

- (CueSyncSet *)filteredSetUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;

- (void)filterUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;

- (CueSyncArray *)sortedArrayUsingDescriptors:(NSArray *)sortDescriptors;


#pragma mark - Set

- (NSMutableSet *)unsafeSet;

- (NSSet *)set;

@end
