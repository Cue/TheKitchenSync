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

#import <Foundation/Foundation.h>
#import "CueTask.h"

@protocol CueTaskQueueDelegate;

/**
 * TODO
 * Documentation forthcoming.
 * For now think of it kind of like GCD queue, but better.
 */
@interface CueTaskQueue : NSObject

/**
 * For custom strategies regarding deduping. 
 * E.g. multiple render requests can be collapsed to the most recent one.
 */
@property (assign) id<CueTaskQueueDelegate> delegate;

/**
 * The observed default for NSThread is 0.5f, which is what we will use.
 */
@property (nonatomic) double threadPriority;

- (id)initWithName:(NSString *)name;

- (void)addTask:(CueTask *)task;

- (BOOL)isEmpty;

- (void)startWithThreadCount:(int)count;

- (void)finish;

@end

/**
 * For custom strategies regarding deduping.
 * E.g. multiple render requests can be collapsed to the most recent one.
 */
@protocol CueTaskQueueDelegate

- (NSArray *)collapsedTasksForTasks:(NSArray *)tasks;

@end
