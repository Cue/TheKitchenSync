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

#import "CueSafeCollectionsTest.h"
#import "TheKitchenSync.h"

@implementation CueSafeCollectionsTest

- (void)testDictionaryBasic;
{
    NSMutableDictionary *dict = [[@{ @"key1" : @"val1", @2 : @YES } mutableCopy] autorelease];
    CueSafeDictionary *cDict = [dict cueConcurrent];
    AssertObjectEquals(cDict.unsafeDictionary, dict);
    
    dict[@"key3"] = @"val3";
    cDict[@"key3"] = @"val3";
    AssertObjectEquals(cDict.unsafeDictionary, dict);
}

- (void)testDictionaryProtocols;
{
    CueSafeDictionary *cDict = [@{@"foo" : @"bar", @"tofu" : @"baz"} cueConcurrent];
    CueSafeDictionary *test = [[cDict copy] autorelease];
    AssertObjectEquals(cDict, test);
    
    test = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:cDict]];
    AssertObjectEquals(cDict, test);
}

- (void)testArrayBasic;
{
    NSMutableArray *arr = [[@[ @1, @"two", @3.14] mutableCopy] autorelease];
    CueSafeArray *cArr = [arr cueConcurrent];
    AssertObjectEquals(cArr.unsafeArray, arr);
    
    [arr addObject:@"4"];
    [cArr addObject:@"4"];
    AssertObjectEquals(cArr.unsafeArray, arr);
    
    arr[3] = @"5";
    cArr[3] = @"5";
    AssertObjectEquals(cArr.unsafeArray, arr);
}

- (void)testArrayProtocols;
{
    CueSafeArray *cArr = [@[@"foo", @"bar", @"tofu", @"baz"] cueConcurrent];
    CueSafeArray *test = [[cArr copy] autorelease];
    AssertObjectEquals(cArr, test);
    
    test = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:cArr]];
    AssertObjectEquals(cArr, test);
}

@end
