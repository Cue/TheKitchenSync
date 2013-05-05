CueConcurrency
===========================

Cue's concurrency library provides you with a basic set of advanced locks and collections, similar to what you might find in Java. 

## Installation
There are three ways to integrate CueConcurrency into your project:
* Use [Cocoapods](http://cocoapods.org/)
* Import CueConcurrency.xcodeproj
* Pick and choose the files you need.

### Cocoapods
If you're already using Cocoapods then this will be very easy, just add the following line to your Podfile
and type 'pod install':
~~~~~~~~~~~~~~.ruby
pod "CueConcurrency"
~~~~~~~~~~~~~~

If you haven't used Cocoapods before, read the installation instructions [here](http://cocoapods.org/#install).

### CueConcurrency.xcodeproj
You can also just take the included project file and drag it from finder into your Xcode workspace/project. 
Once you've done that,  you'll need to add CueConcurrency/Classes to your headers path and link against libCueConcurrency.a

### Pick and choose
If you only need a single class, just grab it! Make sure to get any of that file's #includes as well!


## Collections
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

## Locks
For more complex locking schemes, CueConcurrency provides a simple fair lock implementation, as well as a readwrite lock.

Also provided is a C++ stack-based locking system, which guarantees unlocking when execution leaves the current scope.
This helps minimize forgotten unlocks and guarantees correct exception cleanup.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.objc
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
