//
//  CCThreadedTest
//  Greplin
//
//  Created by Robby Walker on 7/19/12.
//  Copyright 2012 Greplin, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CueTestableLock.h"

/**
 * Utils for running concurrency unit tests.
 */
@interface CCThreadSteps : NSObject {
    NSMutableDictionary *_threads;
    BOOL _isStopped;
}

- (void)runOnThread:(int)thread block:(void (^)())block;

- (void)asyncRunOnThread:(int)thread block:(void (^)())block;

- (void)asyncRunOnThread:(int)threadId untilLocked:(id<CueTestableLock>)lock block:(void (^)())block;

@end
