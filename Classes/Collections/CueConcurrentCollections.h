//
//  CCConcurrentStructures.h
//  CueCore
//
//  Created by Aaron Sarazan on 5/4/13.
//  Copyright (c) 2013 Cue. All rights reserved.
//

#import "CueConcurrentArray.h"
#import "CueConcurrentDictionary.h"

@interface NSArray (CueConcurrentCollections)
- (CueConcurrentArray *)cueConcurrent;
@end

@interface NSDictionary (CueConcurrentCollections)
- (CueConcurrentDictionary *)cueConcurrent;
@end
