/*
 * Copyright 2013 The CueConcurrency Authors.
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

#import "CueTask.h"

/**
 * A basic deduping key. Takes its hash from 'value' property.
 * Retains 'value' on copy.
 */
@interface CueSimpleTaskKey : NSObject <CueTaskKey>

/**
 * Hash source. Retained on copy.
 */
@property (retain) id value;

/**
 * Arbitrary value for sorting in the task queue.
 */
@property (readonly) double priority;

- (id)initWithPriority:(double)priority andValue:(id)value;

+ (CueSimpleTaskKey *)keyWithPriority:(double)priority andValue:(id)value;

@end
