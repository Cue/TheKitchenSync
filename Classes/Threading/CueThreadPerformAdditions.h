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

/**
 * Provides block-based alternatives to NSThreadPerformAdditions
 * 
 * Obviously, a calling object is no longer necessary when using blocks,
 * but the API familiarity is nice.
 *
 * If you don't have an object handy, just call these on NSObject itself.
 */
@interface NSObject (CueThreadPerformAdditions)

- (void)cuePerformBlockOnMainThread:(void(^)())block;

- (void)cuePerformBlockInBackground:(void(^)())block;

- (void)cuePerformBlock:(void(^)())block afterDelay:(NSTimeInterval)delay;

- (void)cuePerformBlock:(void(^)())block onThread:(NSThread *)thread waitUntilDone:(BOOL)wait;

- (void)cuePerformSelectorOnMainThread:(SEL)aSelector withObject:(id)arg afterDelay:(NSTimeInterval)delay;

@end
