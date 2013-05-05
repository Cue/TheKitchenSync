//
//  CCCustomDealloc
//  Greplin
//
//  Created by Robby Walker on 2/8/13.
//  Copyright 2013 Greplin, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^CCTestBlock)(void);

/**
 * Object that calls a custom block upon dealloc.
 */
@interface CCCustomDealloc : NSObject {
    CCTestBlock _dealloc;
}

- (id)initWith:(CCTestBlock)customDealloc;

@end
