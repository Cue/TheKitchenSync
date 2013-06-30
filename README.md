# A Tool Belt for iOS Concurrency

Cue's iOS concurrency library, _TheKitchenSync_, provides you with a set of advanced locks and thread-safe collections, similar to what you might find in Java. 

## Installation
You can get TheKitchenSync in your project within about 5 minutes: [step-by-step installation instructions](/Documentation/INSTALL.md). Then just `#import "TheKitchenSync.h"` and you're ready to roll!

## Collections
Cue's thread-safe array and dictionary classes support all of the basic operations of arrays and dictionaries, 
as well as the new subscript operators:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.objc
CueSyncArray *syncArray = [@[@"some", @"items"] cueConcurrent];
CueSyncDictionary *syncDict = [@{ @"key" : @"val" } cueConcurrent];
[self cuePerformBlockInBackground:^{
  [syncArray insertObject:@"more" atIndex:1];
  syncDict[@"key2"] = @"val2";
}];

int i = 0;

// We cannot guarantee safety during normal for-loops, but foreach loops are safe.
for (id obj in syncArray) {
  // Since we copy the array before enumerating, you can even mutate mid-loop!
  syncArray[i++] = @"I've been mutated!";
}

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## CueTaskQueue
The CueTaskQueue is similar in concept to a dispatch queue, but with more control. For one, it explicitly maintains a user-configurable number of dedicated threads for execution.
In addition, it allows the client to set a delegate to implement custom task deduping logic.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.objc
CueTaskQueue *queue = [[CueTaskQueue alloc] initWithName:@"PewPewQueue"];

// relatively low-priority queue.
queue.threadPriority = 0.3; 

// single-thread so you don't have to worry about @synchronizing everything.
[queue startWithThreadCount:1]; 

for (int i = 0; i < 10; ++i) {
  [queue addTask:[CueBlockTask taskWithKey:@(i) priority:1.0f executionBlock:^(CueTask *task) {
    NSLog(@"Task %d reporting for duty!", i);
  }]];
}

// Cleans up and removes the thread.
[queue finish]; 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## CueLoadingCache and CueLRUCache
Similar to [Guava MapMaker](http://docs.guava-libraries.googlecode.com/git-history/v10.0.1/javadoc/com/google/common/collect/MapMaker.html), 
CueLoadingCache and CueLRUCache are thread-safe containers that allow programmatic generation of values by key. Simply pass a loader block to either object, and it will apply that block to every key it is passed:

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

## Locks
For more complex locking schemes, TheKitchenSync provides __CueFairLock__, as well as a __CueReadWriteLock__, 
although we will warn you that in benchmarking, CueReadWriteLock proved to be far slower than normal or recursive locks. 
We are working on improving it, but in the meantime think hard about whether you want to incur this overhead.

Also provided is __CueStackLock__, which uses stack allocation to guarantee unlocking when execution leaves the current scope.
This helps minimize forgotten unlocks and guarantees correct exception cleanup.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.objc
- (BOOL)safeLockedQuery {
  // Guarantees lock until scope ends.
  CueStackLock(_lock);
  if ([self needsToBreak]) {
    return NO;
  }
  return [self potentialThrowQuery];  
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Make sure you compile as Objective C++ when using CueStackLock. 
Generally this means changing your file extension from .m to .mm

## Contributing

We know there is a lot more that can be done to build great libraries, and concurrency is hard!

We're always happy to receive pull requests! Here are some potential improvements:
- In `-[CueLRUCache loaderForKey]`, it's possible to improve the locking performance on reads by getting more granular with the OrderedDictionary implementation, and perhaps writing a LinkedList implementation instead of using NSMutableArray.

## License

Copyright 2013 TheKitchenSync Authors.

Published under The Apache License, see LICENSE
