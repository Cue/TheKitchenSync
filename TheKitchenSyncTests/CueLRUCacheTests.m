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

#import "CueLRUCacheTests.h"
#import "CueLRUCache.h"
#import "OrderedDictionary.h"

@implementation CueLRUCacheTests

- (void)testLRU;
{
    CueLRUCache *cache = [[[CueLRUCache alloc] initWithLoader:nil isMemorySensitive:NO size:5] autorelease];
    [cache setObject:@"1" forKey:@1];
    [cache setObject:@"2" forKey:@2];
    [cache setObject:@"3" forKey:@3];
    [cache setObject:@"4" forKey:@4];
    [cache setObject:@"5" forKey:@5];
    
    id dict = @{@1 : @"1",@2 : @"2",@3 : @"3",@4 : @"4",@5 : @"5" };
    id cacheDict = cache.dictionaryRepresentation;
    STAssertEqualObjects(cacheDict, dict, @"Did not insert correctly");
    
    [cache setObject:@"6" forKey:@6];
    dict = @{@2 : @"2",@3 : @"3",@4 : @"4",@5 : @"5",@6 : @"6"};
    cacheDict = cache.dictionaryRepresentation;
    STAssertEqualObjects(cacheDict, dict, @"Did not remove correctly");
}

- (void)testOrderedDictionaryCopy;
{
    OrderedDictionary *dict = [[[OrderedDictionary alloc] init] autorelease];
    [dict setObject:@"1" forKey:@1];
    [dict setObject:@"2" forKey:@2];
    [dict setObject:@"3" forKey:@3];
    OrderedDictionary *unordered = [[[OrderedDictionary alloc] init] autorelease];
    [unordered setObject:@"1" forKey:@1];
    [unordered setObject:@"3" forKey:@3];
    [unordered setObject:@"2" forKey:@2];
    STAssertFalse([dict isEqual:unordered], @"equivalence doesn't respect ordering");    
    OrderedDictionary *cp = [[dict copy] autorelease];
    STAssertEqualObjects(dict, cp, @"Copy didn't create equivalent object");
}

- (void)testOrderedDictionaryRemove;
{
    OrderedDictionary *dict = [[[OrderedDictionary alloc] init] autorelease];
    [dict setObject:@"1" forKey:@1];
    [dict setObject:@"2" forKey:@2];
    [dict setObject:@"3" forKey:@3];
    [dict removeBack];
    
    id other = @{@1:@"1",@2:@"2"};
    STAssertEqualObjects(other, dict, @"Did not removeBack correctly");      
}

// Make sure we get expected LRU eviction
- (void)testLRUOrdering;
{
    // Check that ordering is updated by insertion
    CueLRUCache *cache = [[[CueLRUCache alloc] initWithLoader:nil isMemorySensitive:NO size:3] autorelease];
    [cache setObject:@"1" forKey:@1];
    [cache setObject:@"2" forKey:@2];
    [cache setObject:@"3" forKey:@3]; // Cache: 1, 2, 3
    [cache setObject:@"4" forKey:@4]; // Cache: 2, 3, 4
    [cache setObject:@"5" forKey:@5]; // Cache: 3, 4, 5
    
    OrderedDictionary *cacheDict = (OrderedDictionary *)[cache dictionaryRepresentation];
    NSDictionary *expectedCacheDict = @{@3: @"3", @4: @"4", @5: @"5"};
    STAssertEqualObjects(cacheDict, expectedCacheDict, @"Unexpected objects in cache");
    
    // Check that ordering is updated by reads as well
    [cache objectForKey:@3]; // Cache: 4, 5, 3
    [cache setObject:@"6" forKey:@6]; // Cache: 5, 3, 6
    
    cacheDict = (OrderedDictionary *)[cache dictionaryRepresentation];
    expectedCacheDict = @{@5: @"5", @3: @"3", @6: @"6"};
    STAssertEqualObjects(cacheDict, expectedCacheDict, @"Unexpected objects in cache");
}

@end
