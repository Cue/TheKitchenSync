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


/**
 * Interface that CueSyncArray shares with NSArray
 */
@protocol ICueArray <NSFastEnumeration, NSCoding, NSCopying, NSMutableCopying>
@required


#pragma mark - Query

- (BOOL)containsObject:(id)anObject;

- (NSUInteger)indexOfObject:(id)anObject;

- (NSUInteger)count;

- (id)objectAtIndex:(NSUInteger)index;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end
typedef NSObject<ICueArray> CueArray;


/**
 * Interface that CueSyncArray shares with NSMutableArray
 */
@protocol ICueMutableArray <ICueArray>
@required


#pragma mark - Add

- (void)addObject:(id)object;

- (void)addObjectsFromArray:(NSArray *)array;

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index;

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)setArray:(NSArray *)otherArray;


#pragma mark - Remove

- (void)removeObject:(id)object;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)removeLastObject;

- (void)removeAllObjects;

@end
typedef NSObject<ICueMutableArray> CueMutableArray;

/**
 * A thread-safe array object composed of
 * an NSMutableArray and a lock.
 *
 * Should only be iterated using fast-enumeration. i++ is not synchronized.
 */
@interface CueSyncArray : NSObject <ICueMutableArray>


#pragma mark - Static Factory

+ (instancetype)from:(NSArray *)array;


#pragma mark - Init

- (id)init;

- (id)initWithArray:(NSArray *)array;


#pragma mark - Filter and Sort

- (CueSyncArray *)filteredArrayUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;

- (void)filterUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;

- (CueSyncArray *)sortedArrayUsingDescriptors:(NSArray *)sortDescriptors;

- (void)sortUsingDescriptors:(NSArray *)sortDescriptors;


#pragma mark - Array

- (NSMutableArray *)unsafeArray;

- (NSArray *)array;

@end
