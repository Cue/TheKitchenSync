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
#import "CueSyncDictionary.h"
#import "CueSyncSet.h"

@interface NSArray (CueSyncCollections) <ICueArray>
- (CueSyncArray *)cueConcurrent;
- (CueSyncSet *)cueConcurrentSet;
@end

@interface NSMutableArray (CueSyncCollections) <ICueMutableArray>
@end


@interface NSDictionary (CueSyncCollections) <ICueDictionary>
- (CueSyncDictionary *)cueConcurrent;
@end

@interface NSMutableDictionary (CueSyncCollections) <ICueMutableDictionary>
@end


@interface NSSet (CueSyncCollections) <ICueSet>
- (CueSyncSet *)cueConcurrent;
@end

@interface NSMutableSet (CueSyncCollections) <ICueMutableSet>
@end
