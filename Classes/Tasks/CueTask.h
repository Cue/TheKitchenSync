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

extern volatile int CueTaskInstanceCount;


@protocol CueTaskKey;

/**
* A unit of work to enqueue in CueTaskQueue.
*/
@interface CueTask : NSObject

/**
* Key interface used for hashing and priority.
*/
@property (retain) NSObject<CueTaskKey> *key;

/**
* Task Priority.
*/
@property (readonly) double priority;

/**
* Is Cancelled.
*/
@property (readonly) BOOL isCancelled;

/**
* Is Finished.
*/
@property (readonly) BOOL isFinished;

/**
* Used in collapsing and deduping task lists.
*/
@property (readonly) NSTimeInterval creationTime;


- (id)initWithKey:(NSObject<CueTaskKey> *)key;

- (void)cancel;

- (void)execute;

- (void)main; // implement in subclass

- (BOOL)ignoreDeadKey; // run even if the key is dead. default is NO

@end


/**
* Used for deduping in a task queue.
*/
@protocol CueTaskKey <NSCopying>
@required

/**
* Is Cancelled.
*/
@property (readonly) BOOL isCancelled;

- (void)cancel;

- (NSString *)keyString;

@end
