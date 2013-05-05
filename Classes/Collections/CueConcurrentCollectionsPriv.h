//
//  CueConcurrentCollectionsPriv.h
//  CueConcurrency
//
//  Created by Aaron Sarazan on 5/4/13.
//  Copyright (c) 2013 Cue. All rights reserved.
//

#import "CueStackLock.h"

#ifndef CueConcurrency_CueConcurrentCollectionsPriv_h
#define CueConcurrency_CueConcurrentCollectionsPriv_h

#define READ CueStackLock(_lock);
#define WRITE CueStackLockWrite(_lock);

#endif
