//
//  CueThreadLocal
//  Greplin
//
//  Created by Robby Walker on 7/18/12.
//  Copyright 2012 Greplin, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Convenience interface for objc thread-local storage.
 */
@interface CueThreadLocal : NSObject

- (id)get;

- (void)set:(id)value;

- (void)remove;

@end
