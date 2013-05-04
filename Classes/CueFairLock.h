//
//  CueFairLock
//  Greplin
//
//  Created by Robby Walker on 7/18/12.
//  Copyright 2012 Greplin, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CueTestableLock.h"

/**
 * Cue Fair Lock
 */
@interface CueFairLock : NSObject <NSLocking, CueTestableLock>

@end
