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

#import "CueValueLoader.h"

@implementation CueValueLoader

- (id)initWithBlock:(id (^)())block;
{
    if ((self = [super init])) {
        _value = nil;
        _loader = [block copy];
    }
    return self;
}

- (id)get;
{
    @synchronized (self) {
        if (!_value) {
            _value = [_loader() retain];
        }
        return [[_value retain] autorelease];
    }
}

- (void)set:(id)value;
{
    @synchronized (self) {
        if (_value != value) {
            [_value release];
            _value = [value retain];
        }
    }
}

- (NSString *)description;
{
    return [[self get] description];
}

- (void)dealloc;
{
    [_value release];
    [_loader release];
    [super dealloc];
}

@end
