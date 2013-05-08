TheKitchenSync - Concurrency by Cue
===========================

Cue's concurrency library provides you with a set of advanced locks and thread-safe collections, similar to what you might find in Java. 

## Installation
You can get TheKitchenSync in your project within about 5 minutes: [step-by-step installation instructions](/Documentation/INSTALL.md). Then just `#import "TheKitchenSync.h" and you're ready to roll!

## Collections
Cue's thread-safe array and dictionary classes support all of the basic operations of arrays and dictionaries, 
as well as the new subscript operators:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.objc
CueConcurrentArray *safeArray = [@[@"some", @"items"] cueConcurrent];
CueConcurrentDictionary *safeDict = [@{ @"key" : @"val" } cueConcurrent];
[self cuePerformBlockInBackground:^{
  [safeArray insertObject:@"more" atIndex:1];
  safeDict[@"key2"] = @"val2";
}];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Locks
For more complex locking schemes, TheKitchenSync provides __CueFairLock__, as well as a __CueReadWriteLock__.

Also provided is __CueStackLock__, which uses stack allocation to guarantee unlocking when execution leaves the current scope.
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
Make sure you compile as Objective C++ when using CueStackLock. 
Generally this means changing your file extension from .m to .mm

## CueTaskQueue
The CueTaskQueue is similar in concept to a dispatch queue, but with more control. For one, it explicitly maintains a user-configurable number of dedicated threads for execution.
In addition, it allows the client to set a delegate to implement custom task deduping logic.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.objc
CueTaskQueue *queue = [[CueTaskQueue alloc] initWithName:@"PewPewQueue"];
queue.threadPriority = 0.3; // relatively low-priority queue.
[queue startWithThreadCount:1]; // single-thread so you don't have to worry about @synchronizing everything.
  __block int count = 0;
  for (int i = 0; i < 10; ++i) {
    [queue addTask:[CueBlockTask taskWithKey:@(count) priority:1.0f executionBlock:^(CueTask *task) {
      NSLog(@"Task %d reporting for duty!", count);
    }]];
  }
[queue finish]; // removes the thread.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## CueLoadingCache
Similar to [Guava MapMaker](http://docs.guava-libraries.googlecode.com/git-history/v10.0.1/javadoc/com/google/common/collect/MapMaker.html), 
the CueLoadingCache is a thread-safe container that allows programmatic generation of values by key. Simply pass a loader block to it, and it will apply that block to every key it is passed:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.objc
// This cache object takes a filename as its key, and returns its NSData from disk.
CueLoadingCache *fileLoader = [[CueLoadingCache alloc] initWithLoader:^id(id key) {
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString * docPath = [paths[0] stringByAppendingFormat:@"/%@",path];
  return [NSData dataWithContentsOfFile:docPath];
} isMemorySensitive:YES];

// Loads from disk the first time...
NSData *valueFirstTime = fileLoader[@"TextFile1.txt"];
// Loads from cache the second time.
NSData *valueSecondTime = fileLoader[@"TextFile1.txt"];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Contributing

We know there is a lot more that can be done to build great libraries, and concurrency is hard!

We're always happy to receive pull requests!

## License

Copyright 2013 TheKitchenSync Authors.

Published under The Apache License, see LICENSE
