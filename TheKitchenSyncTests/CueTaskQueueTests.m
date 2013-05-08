//
//  CueTaskQueueTests
//  Greplin
//
//  Created by Robby Walker on 7/17/12.
//  Copyright 2012 Greplin, Inc. All rights reserved.
//

#import "CueTaskQueueTests.h"
#import "TheKitchenSync.h"

#pragma mark - Keep First Delegate

@interface CCKeepFirstTaskDelegate : NSObject <CueTaskQueueDelegate>
@end
@implementation CCKeepFirstTaskDelegate
- (NSArray *)collapsedTasksForTasks:(NSArray *)tasks;
{
    return [tasks subarrayWithRange:NSMakeRange(0,1)];
}
@end


#pragma mark - Tests

@implementation CueTaskQueueTests {
    CueTaskQueue *_queue;
    NSMutableArray *_result;
    void (^_add)(CueTask *);
    void (^_addWithThread)(CueTask *);
    NSConditionLock *_gate;
    void (^_openGate)(CueTask *);
    void (^_waitForGate)(CueTask *);
}

- (void)setUp;
{
    [super setUp];
    _queue = [[CueTaskQueue alloc] initWithName:@"TaskThread"];

    _result = [[NSMutableArray array] retain];
    _add = [^(CueTask *task) {
        [_result addObject:((CueSimpleTaskKey *)task.key).value];
    } copy];
    _addWithThread = [^(CueTask *task) {
        [_result addObject:[NSString stringWithFormat:@"%@-%@",
                           ((CueSimpleTaskKey *)task.key).value, [NSThread currentThread].name]];
    } copy];

    _gate = [[NSConditionLock alloc] initWithCondition:NO];
    _openGate = [^(CueTask *task) {
        [_result addObject:[NSString stringWithFormat:@"open-%@", [NSThread currentThread].name]];
        [_gate lockWhenCondition:NO];
        [_gate unlockWithCondition:YES];
    } copy];
    _waitForGate = [^(CueTask *task) {
        [_result addObject:[NSString stringWithFormat:@"waiting-%@", [NSThread currentThread].name]];
        [_gate lockWhenCondition:YES];
        [_result addObject:[NSString stringWithFormat:@"waited-%@", [NSThread currentThread].name]];
        [_gate unlock];
    } copy];
}

- (void)tearDown;
{
    [super tearDown];
    [_queue release];
    [_result release];
    [_add release];
    [_addWithThread release];
    [_gate release];
    [_openGate release];
    [_waitForGate release];
}

static unichar _lastChar(NSString *string)
{
    return [string characterAtIndex:string.length - 1];
}

- (void)assertResult:(NSMutableArray *)expected;
{
    if (_lastChar([expected objectAtIndex:0]) == 'A') {
        unichar lastChar = _lastChar([_result objectAtIndex:0]);
        unichar opposite = lastChar == '1' ? '2' : '1';
        for (int i = 0; i < [expected count]; i++) {
            NSString *item = [expected objectAtIndex:i];
            unichar c = _lastChar(item) == 'A' ? lastChar : opposite;
            [expected replaceObjectAtIndex:i
                                withObject:[NSString stringWithFormat:@"%@%c",
                                            [item substringToIndex:item.length - 1], c]];
        }
    }
    AssertObjectEquals(expected, _result);
}


- (void)testPriority;
{
    [_queue addTask:[CueBlockTask taskWithKey:@"0" priority:0 executionBlock:_add]];
    [_queue addTask:[CueBlockTask taskWithKey:@"2" priority:2 executionBlock:_add]];
    [_queue addTask:[CueBlockTask taskWithKey:@"1" priority:1 executionBlock:_add]];

    [_queue startWithThreadCount:1];
    [_queue finish];

    [self assertResult:[NSMutableArray arrayWithObjects:@"2", @"1", @"0", nil]];
}

- (void)testAddAfterStart;
{
    [_queue startWithThreadCount:1];
    [_queue addTask:[CueBlockTask taskWithKey:@"0" priority:0 executionBlock:_add]];
    [_queue addTask:[CueBlockTask taskWithKey:@"2" priority:2 executionBlock:_add]];
    [_queue addTask:[CueBlockTask taskWithKey:@"1" priority:1 executionBlock:_add]];
    [_queue finish];

    // Priority may or may not come in to play based on if the tasks are added when the queue is empty.
    AssertCount(3, _result, @"all tasks should be completed");
    NSSet *expected = [NSSet setWithObjects:@"0", @"1", @"2", nil];
    AssertObjectEquals(expected, [NSSet setWithArray:_result]);
}

- (void)testCollapse;
{
    _queue.delegate = [[CCKeepFirstTaskDelegate alloc] autorelease];

    [_queue addTask:[CueBlockTask taskWithKey:@"0" priority:0 executionBlock:_add]];
    [_queue addTask:[CueBlockTask taskWithKey:@"1" priority:1 executionBlock:_add]];
    [_queue addTask:[CueBlockTask taskWithKey:@"0" priority:2 executionBlock:_add]];

    [_queue startWithThreadCount:1];
    [_queue finish];

    [self assertResult:[NSMutableArray arrayWithObjects:@"0", @"1", nil]];
}

- (void)testMultipleThreads;
{
    [_queue startWithThreadCount:2];
    [_queue addTask:[CueBlockTask taskWithKey:@"consumeThread1" priority:1 executionBlock:_waitForGate]];
    [_queue addTask:[CueBlockTask taskWithKey:@"thread2" priority:1 executionBlock:_addWithThread]];
    [_queue addTask:[CueBlockTask taskWithKey:@"thread2" priority:1 executionBlock:_addWithThread]];
    [_queue addTask:[CueBlockTask taskWithKey:@"thread2" priority:0 executionBlock:_openGate]];
    [_queue finish];

    [self assertResult:[NSMutableArray arrayWithObjects:@"waiting-TaskThread-A",
                                                        @"thread2-TaskThread-B",
                                                        @"thread2-TaskThread-B",
                                                        @"open-TaskThread-B",
                                                        @"waited-TaskThread-A",
                                                        nil]];
}

- (void)testKeyConcurrencyProtection;
{
    [_queue startWithThreadCount:2];
    [_queue addTask:[CueBlockTask taskWithKey:@"key1" priority:2 executionBlock:_waitForGate]];
    [_queue addTask:[CueBlockTask taskWithKey:@"key1" priority:1 executionBlock:_addWithThread]];
    [_queue addTask:[CueBlockTask taskWithKey:@"key2" priority:0 executionBlock:_openGate]];
    [_queue finish];

    // The high priority key1 tasks can't run while the original key1 task is running, so it ends up running last.
    // Slightly harder to test because we don't guarantee which thread runs key1.
    NSString *last = [_result lastObject];
    AssertObjectEquals(@"key1-", [last substringToIndex:5]);
    [_result removeLastObject];

    [self assertResult:[NSMutableArray arrayWithObjects:@"waiting-TaskThread-A",
                                                        @"open-TaskThread-B",
                                                        @"waited-TaskThread-A",
                                                        nil]];
}

- (void)testProperDealloc;
{
    [_queue startWithThreadCount:1];

    @autoreleasepool {
        [_queue addTask:[CueBlockTask taskWithKey:@"0" priority:0 executionBlock:_add]];
        [_queue addTask:[CueBlockTask taskWithKey:@"1" priority:1 executionBlock:_add]];
        [_queue addTask:[CueBlockTask taskWithKey:@"0" priority:2 executionBlock:_add]];
    }

    [_queue finish];

    int count = CueTaskInstanceCount;
    STAssertEquals(count, 0, @"Tasks did not properly deallocate");
}

@end
