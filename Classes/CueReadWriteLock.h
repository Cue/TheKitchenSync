//
//  CueReadWriteLock
//  Greplin
//
//  Created by Robby Walker on 7/18/12.
//  Copyright 2012 Greplin, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CueFairLock.h"
#import "CueThreadLocal.h"

/**
 * Cue Read/Write Lock.
 */
@interface CueReadWriteLock : NSObject <CueTestableLock>

- (void)lockForWrite;

- (void)lockForRead;

- (void)lock; // Synonym for lockForRead

- (void)unlock;


@end
