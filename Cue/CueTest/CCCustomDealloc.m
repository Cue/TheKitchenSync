//
//  CCCustomDealloc
//  Greplin
//
//  Created by Robby Walker on 2/8/13.
//  Copyright 2013 Greplin, Inc. All rights reserved.
//
#import "CCCustomDealloc.h"


@implementation CCCustomDealloc

- (id)initWith:(CCTestBlock)customDealloc;
{
    if ((self = [super init])) {
        _dealloc = [customDealloc copy];
    }
    return self;
}

- (void)dealloc;
{
    _dealloc();
    [_dealloc release];
    [super dealloc];
}

@end
