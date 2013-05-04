//
//  CueTestableLock
//  Greplin
//
//  Created by Robby Walker on 7/19/12.
//  Copyright 2012 Greplin, Inc. All rights reserved.
//

/**
 * Testing protocol for unit tests.
 */
@protocol CueTestableLock

- (int32_t)getCounterForTesting;

@end
