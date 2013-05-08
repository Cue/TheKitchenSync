//
//  CueLoadingCacheTests.m
//  Greplin
//
//  Created by Robby Walker on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CueLoadingCacheTest.h"
#import "TheKitchenSync.h"

@implementation CueLoadingCacheTest

- (void)_doSimpleTest:(BOOL)isMemorySensitive;
{
    __block int count = 0;
    
    CueLoadingCache *cache = [[CueLoadingCache alloc] initWithLoader:^id (id parameter) {
        return [NSString stringWithFormat:@"%@%d", parameter, ++count];        
    } isMemorySensitive:isMemorySensitive];
    
    AssertObjectEquals(@"A1", [cache objectForKey:@"A"]);
    AssertObjectEquals(@"B2", [cache objectForKey:@"B"]);
    AssertObjectEquals(@"A1", [cache objectForKey:@"A"]);
}

- (void)testSimple;
{
    [self _doSimpleTest:NO];
}

- (void)testSimpleMemorySensitive;
{
    [self _doSimpleTest:YES];
}

@end
