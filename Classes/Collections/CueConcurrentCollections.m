//
//  CCConcurrentStructures.m
//  CueCore
//
//  Created by Aaron Sarazan on 5/4/13.
//  Copyright (c) 2013 Cue. All rights reserved.
//

#import "CueConcurrentCollections.h"

@implementation NSArray (CueConcurrentCollections)

- (CueConcurrentArray *)cueConcurrent;
{
    return [CueConcurrentArray from:self];
}

@end

@implementation NSDictionary (CueConcurrentCollections)

- (CueConcurrentDictionary *)cueConcurrent;
{
    return [CueConcurrentDictionary from:self];
}

@end
