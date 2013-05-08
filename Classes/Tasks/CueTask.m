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

#import <libkern/OSAtomic.h>
#import "CueTask.h"

volatile int CueTaskInstanceCount = 0;

@implementation CueTask

- (id)init;
{
    self = [super init];
    if (self) {
        OSAtomicIncrement32(&CueTaskInstanceCount);
    }
    return self;
}

- (id)initWithKey:(NSObject<CueTaskKey> *)key;
{
    self = [self init];
    if (self) {
        _creationTime = [[NSDate date] timeIntervalSince1970];
        self.key = key;
    }

    return self;
}

- (double)priority;
{
    return 0.0;
}

- (void)execute;
{
    @autoreleasepool {
        if (self.isCancelled) {
            return;
        }
        
        if (![self ignoreDeadKey] && self.key.isCancelled) {
            return;
        }

        [self main];
        _isFinished = YES;
    }
}

- (BOOL)ignoreDeadKey;
{
    return NO;
}

- (void)main;
{
}

- (void)cancel;
{
    _isCancelled = YES;
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@<%@>", NSStringFromClass([self class]), [self key]];
}

- (void)dealloc;
{
    OSAtomicDecrement32(&CueTaskInstanceCount);
    [_key release];
    [super dealloc];
}

@end
