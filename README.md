CueConcurrency
===========================

Cue's concurrency library provides you with a basic set of advanced locks and collections, similar to what you might find in Java. 

## Installation
You can get CueConcurrency in your project within about 5 minutes: [step-by-step installation instructions](/Documentation/INSTALL.md)

## How to Use

### Collections
Cue's thread-safe array and dictionary classes support all of the basic operations of arrays and dictionaries, 
as well as the new subscript operators:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.objc
#import "CueConcurrentCollections.h"
/*...*/
CueConcurrentArray *safeArray = [@[@"some", @"items"] cueConcurrent];
CueConcurrentDictionary *safeDict = [@{ @"key" : @"val" } cueConcurrent];
BACKGROUND(^{
  [safeArray insertObject:@"more" atIndex:1];
  safeDict[@"key2"] = @"val2";
});
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Locks
For more complex locking schemes, CueConcurrency provides __CueFairLock__, as well as a __CueReadWriteLock__.

Also provided is __CueStackLock__, which uses stack allocation to guarantee unlocking when execution leaves the current scope.
This helps minimize forgotten unlocks and guarantees correct exception cleanup.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.objc
#import "CueStackLock.h"
/*
 * Make sure you compile as Objective C++ when using CueStackLock. 
 * Generally this means changing your file extension from .m to .mm
 * /
- (BOOL)safeLockedQuery {
  CueStackLock(_lock);
  if ([self needsToBreak]) {
    return NO;
  }
  return [self potentialThrowQuery];  
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Contributing

We know there is a lot more that can be done to build great tools so we can all write more performant applications.

We're always happy to receive pull requests!

## License

Copyright 2013 The CueConcurrency Authors.

Published under The Apache License, see LICENSE
