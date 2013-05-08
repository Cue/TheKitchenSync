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

#import "CueThreadPerformAdditions.h"

@implementation NSObject (CueThreadPerformAdditions)


#pragma mark - Block

- (void)_cuePerformBlock:(void(^)())block;
{
    @autoreleasepool {
        block();
        [block release];
    }
}

- (void)cuePerformBlockInBackground:(void(^)())block;
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_async(queue, block);
}

- (void)cuePerformBlockOnMainThread:(void(^)())block;
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        [self performSelectorOnMainThread:@selector(_cuePerformBlock:) withObject:[block copy] waitUntilDone:NO];
    }
}

- (void)cuePerformBlock:(void(^)())block onThread:(NSThread *)thread waitUntilDone:(BOOL)wait;
{
    if ([[NSThread currentThread] isEqual:thread]) {
        block();
    } else {
        [self performSelector:@selector(_cuePerformBlock:) onThread:thread withObject:[block copy] waitUntilDone:wait];
    }
}

- (void)cuePerformBlock:(void(^)())block afterDelay:(NSTimeInterval)delay;
{
    [self performSelector:@selector(_cuePerformBlock:) withObject:[block copy] afterDelay:delay];
}


#pragma mark - Selector

- (void)_cueMainThreadPerformSelector:(NSDictionary *)args;
{
    [args[@"sender"] performSelector:(SEL)[args[@"selector"] pointerValue]
                          withObject:args[@"object"]
                          afterDelay:[args[@"delay"] doubleValue]];
}


- (void)cuePerformSelectorOnMainThread:(SEL)aSelector withObject:(id)arg afterDelay:(NSTimeInterval)delay;
{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSValue valueWithPointer:aSelector], @"selector",
                          self, @"sender",
                          @(delay), @"delay",
                          arg, @"object", nil];
    [self performSelectorOnMainThread:@selector(_cueMainThreadPerformSelector:) withObject:args waitUntilDone:NO];
}

@end
