//
//  CueThreadLocal
//  Greplin
//
//  Created by Robby Walker on 7/18/12.
//  Copyright 2012 Greplin, Inc. All rights reserved.
//

#import "CueThreadLocal.h"

@interface CueThreadLocalKey : NSObject {
    int64_t _value;
}
@end

@implementation CueThreadLocalKey

- (id)initWithValue:(int64_t)value;
{
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (NSUInteger)hash;
{
    return (NSUInteger) (_value % NSUIntegerMax);
}

- (BOOL)isEqual:(id)object;
{
    return [super isMemberOfClass:[CueThreadLocalKey class]] && _value == ((CueThreadLocalKey *)object)->_value;
}

- (id)copyWithZone:(NSZone *)zone;
{
    return [[CueThreadLocalKey allocWithZone:zone] initWithValue:_value];
}

@end


@implementation CueThreadLocal {
    id _key;
}

- (id)init;
{
    if ((self = [super init])) {
        _key = [[CueThreadLocalKey alloc] initWithValue:(int64_t)self];
        [self remove]; // On the one in a million chance that we're reusing a key, clear the state.
    }
    return self;
}

- (void)dealloc;
{
    [_key release];
    [super dealloc];
}

- (id)get;
{
    return [[[NSThread currentThread] threadDictionary] objectForKey:_key];
}

- (void)set:(id)value;
{
    if (!value) {
        [self remove];
    } else {
        [[[NSThread currentThread] threadDictionary] setObject:value forKey:_key];
    }
}

- (void)remove;
{
    [[[NSThread currentThread] threadDictionary] removeObjectForKey:_key];
}

@end
