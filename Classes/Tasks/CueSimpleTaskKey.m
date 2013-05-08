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

#import "CueSimpleTaskKey.h"

@implementation CueSimpleTaskKey
@synthesize isCancelled = _isCancelled;
@synthesize priority = _priority;

- (id)initWithPriority:(double)priority andValue:(id)value;
{
    self = [self init];
    if (self) {
        _priority = priority;
        self.value = value;
    }
    return self;
}

+ (CueSimpleTaskKey *)keyWithPriority:(double)priority andValue:(id)value;
{
    return [[[self alloc] initWithPriority:priority andValue:value] autorelease];
}

- (BOOL)isEqual:(id)object;
{
    return [object isMemberOfClass:[CueSimpleTaskKey class]] && [_value isEqual:[(CueSimpleTaskKey *)object value]];
}

- (id)copyWithZone:(NSZone *)zone;
{
    return [[[self class] allocWithZone:zone] initWithPriority:_priority andValue:_value];
}

- (NSUInteger)hash;
{
    return [_value hash];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"CCSimpleKey<%@, %f>", _value, _priority];
}

- (double)priority;
{
    return _priority;
}

- (NSString *)keyString;
{
    return [_value description];
}

- (void)cancel;
{
    _isCancelled = YES;
}

- (void)dealloc;
{
    [_value release];
    [super dealloc];
}

@end
