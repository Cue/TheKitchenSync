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

#import "CueBlockTask.h"
#import "CueSimpleTaskKey.h"

@implementation CueBlockTask {
    CueTaskBlock _executionBlock;
}

- (id)initWithKey:(NSObject *)key
         priority:(double)priority
   executionBlock:(CueTaskBlock)executionBlock;
{
    self = [super initWithKey:[CueSimpleTaskKey keyWithPriority:priority andValue:key]];
    if (self) {
        _executionBlock = [executionBlock copy];
    }
    return self;
}

+ (CueBlockTask *)taskWithKey:(NSObject *)key
                     priority:(double)priority
               executionBlock:(CueTaskBlock)executionBlock;
{
    return [[[self alloc] initWithKey:key
                             priority:priority
                       executionBlock:executionBlock] autorelease];
}

- (void)execute;
{
    if (_executionBlock) {
        _executionBlock(self);        
    }
}

- (void)dealloc;
{
    [_executionBlock release];
    [super dealloc];
}

- (double)priority;
{
    return [(CueSimpleTaskKey *)self.key priority];
}

@end
