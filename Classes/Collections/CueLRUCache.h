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
 * Like CueLoadingCache, but allows a specified max size. Will trim itself. *
 */
@interface CueLRUCache : NSObject

- (id)initWithLoader:(id (^)(id))block
   isMemorySensitive:(BOOL)memorySensitive
                size:(uint32_t)size;

- (id)objectForKey:(id)key;

- (id)objectForKeyedSubscript:(id)key;

- (id)checkObjectForKey:(id)key; // Returns nil if not found.

- (void)removeObjectForKey:(id)key;

- (void)removeAllObjects;

- (void)setObject:(id)value forKey:(id)key;

- (NSArray *)allKeys;

- (NSArray *)allValues;

- (NSDictionary *)dictionaryRepresentation;

@end
