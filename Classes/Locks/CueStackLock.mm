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

#include "CueStackLock.h"

@interface NSObject()
- (void)lockForWrite;
@end

static NSString * const lockDictKey = @"greplin_thread_lock_key";

static bool HasLock(id lock)
{
    NSMutableSet *locks = [[[NSThread currentThread] threadDictionary] objectForKey:lockDictKey];
    if (!locks) {
        return NO;
    }

    return [locks containsObject:lock];
}

static void AddLock(id lock)
{
    NSMutableSet *locks = [[[[NSThread currentThread] threadDictionary] objectForKey:lockDictKey] retain];
    if (!locks) {
        locks = [[NSMutableSet alloc] init];
        [[[NSThread currentThread] threadDictionary] setObject:locks forKey:lockDictKey];
    }

    [locks addObject:lock];
    [locks release];
}

static void RemoveLock(id lock)
{
    NSMutableSet *locks = [[[NSThread currentThread] threadDictionary] objectForKey:lockDictKey];
    if (!locks) {
        return;
    }
    
    [locks removeObject:lock];
}

CueStackLockObject::CueStackLockObject(id lock, bool preventRelocking, bool lockForWriting, bool acceptNil) :
m_lock([lock retain]),
m_preventRelocking(preventRelocking),
m_needsUnlock(false)
{
    if (acceptNil && !m_lock) {
        return;
    }
    if (!m_lock) {
        @throw [NSException exceptionWithName:@"NilLockException" reason:@"CueStackLock requires a lock" userInfo:nil];
    }
    
    if (!m_preventRelocking || !HasLock(m_lock)) {
        m_needsUnlock = true;
        AddLock(m_lock);
        if (lockForWriting) {
            [m_lock lockForWrite];
        } else {
            [m_lock lock];            
        }
    }
}

CueStackLockObject::~CueStackLockObject()
{
    if (m_needsUnlock) {
        [m_lock unlock];
        RemoveLock(m_lock);
    }
    [m_lock release];
}
