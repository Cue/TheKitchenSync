/*
 * Copyright 2013 TheKitchenSync Authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "CueTaskQueue.h"

#define EMPTY 0
#define NONEMPTY_OR_FINISHED 1

@implementation CueTaskQueue {
    NSString *_name;
    NSMutableArray *_threads;
    NSMutableArray *_tasks;
    NSMutableDictionary *_defer;
    NSConditionLock *_tasksLock;
    NSConditionLock *_finishLock;
}

- (id)initWithName:(NSString *)name;
{
    if ((self = [super init])) {
        _name = [name retain];
        _threads = [[NSMutableArray array] retain];
        _tasks = [[NSMutableArray array] retain];
        _defer = [[NSMutableDictionary dictionary] retain];
        _tasksLock = [[NSConditionLock alloc] initWithCondition:EMPTY];
        _finishLock = nil;
        _threadPriority = 0.5; // Observed default for NSThread
    }
    return self;
}

- (BOOL)isEmpty;
{
    return [_tasks count] == 0 && [_defer count] == 0;
}

- (void)addTask:(CueTask *)task;
{
    if (_finishLock) {
        @throw [NSException exceptionWithName:@"CueTaskQueueFinished"
                                       reason:@"Adding task to queue that is finished"
                                     userInfo:nil];
    }
    [_tasksLock lock];
    NSMutableArray *deferred = [_defer objectForKey:task.key];
    if (deferred) {
        [deferred addObject:task];
        [_tasksLock unlock];
    } else {
        [_tasks addObject:task];
        [_tasksLock unlockWithCondition:NONEMPTY_OR_FINISHED];
    }
}

- (void)setThreadPriority:(double)aThreadPriority;
{
    _threadPriority = aThreadPriority;
    @synchronized (_threads) {
        for (NSThread * thread in _threads) {
            thread.threadPriority = aThreadPriority;
        }
    }
}

- (void)startWithThreadCount:(int)count;
{
    @synchronized (_threads) {
        for (int i = 0; i < count; i++) {
            NSThread *thread = [[[NSThread alloc] initWithTarget:self selector:@selector(main) object:nil] autorelease];
            thread.threadPriority = self.threadPriority;
            thread.name = [NSString stringWithFormat:@"%@-%d", _name, i + 1];
            [_threads addObject:thread];
            [thread start];
        }
    }
}

- (void)finish;
{
    @synchronized (_threads) {
        _finishLock = [[NSConditionLock alloc] initWithCondition:[_threads count]];
    }
    [_tasksLock lock];
    [_tasksLock unlockWithCondition:NONEMPTY_OR_FINISHED];
    [_finishLock lockWhenCondition:0];
    [_finishLock unlock];
}

- (void)main;
{
    while (YES) {
        @autoreleasepool {
            if (_finishLock && [self isEmpty]) {
                [_finishLock lock];
                [_finishLock unlockWithCondition:[_finishLock condition] - 1];
                return;
            }
            [_tasksLock lockWhenCondition:NONEMPTY_OR_FINISHED];
            if ([_tasks count] == 0) {
                [_tasksLock unlock];
                continue;
            }
            
            [_tasks sortUsingDescriptors:
             [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:NO]]];
            CueTask *first = [[[_tasks objectAtIndex:0] retain] autorelease];
            [_tasks removeObjectAtIndex:0];
            
            id<NSCopying> key = first.key;
            
            NSMutableArray *sameKey = [NSMutableArray array];
            [sameKey addObject:first];
            
            for (int i = 0; i < [_tasks count]; i++) {
                CueTask *item = [_tasks objectAtIndex:i];
                if ([item.key isEqual:key]) {
                    [sameKey addObject:item];
                    [_tasks removeObjectAtIndex:i];
                    i--;
                }
            }
            
            CueTask *taskToExecute = nil;
            NSArray *collapsed = _delegate ? [_delegate collapsedTasksForTasks:sameKey] : sameKey;
            if ([collapsed count]) {
                taskToExecute = [collapsed objectAtIndex:0];
            }
            
            NSArray *deferred = [[collapsed mutableCopy] autorelease];
            [_defer setObject:deferred forKey:key];
            
            // Unlock so other clients can continue adding to the task list.
            [_tasksLock unlockWithCondition:(([_tasks count] == 0 && !_finishLock) ? EMPTY: NONEMPTY_OR_FINISHED)];
            
            // TODO(robbyw): Consider catching and handling exceptions.
            [taskToExecute execute];
            
            [_tasksLock lock];
            if ([deferred count]) {
                [_tasks insertObjects:deferred
                            atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [deferred count])]];
                [_tasks removeObjectAtIndex:0]; // The task we just ran.
            }
            [_defer removeObjectForKey:key];
            [_tasksLock unlockWithCondition:(([_tasks count] == 0 && !_finishLock) ? EMPTY: NONEMPTY_OR_FINISHED)];
        }
    }
}

- (void)dealloc;
{
    [_name release];
    [_threads release];
    [_tasks release];
    [_defer release];
    [_tasksLock release];
    [_finishLock release];
    [super dealloc];
}

@end
