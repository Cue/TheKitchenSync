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

#pragma once


/**
 * Convenience macros. Pass an <NSLocking> object to one of these macros
 * to lock it for the remainder of the present scope level.
 */
#define CueStackLock(__lockable__) \
CueStackLockObject __stackLock_##__lockable__(__lockable__)

#define CueStackLockIfSet(__lockable__) \
CueStackLockObject __stackLock_##__lockable__(__lockable__, false, false, true)

#define CueStackLockWrite(__lockable__) \
CueStackLockObject __stackLock_##__lockable__(__lockable__, false, true)

#define CueStackLockNoRelock(__lockable__) \
CueStackLockObject __stackLock_##__lockable__(__lockable__, true)

#ifdef __cplusplus

// Indicates C++11 support, can use lock_guard
#if __cplusplus > 199711L

#import <mutex>

#define CueStackLockStd(__lockable__) \
std::lock_guard<std::mutex> __stackLock_##__lockable__(__lockable__)

#endif

/**
 * This object, when instantiated with an <NSLocking> object,
 * will stay locked for the duration of its lifespan.
 *
 * It is intended to be stack allocated, so as to provide worry-free
 * local locking via the RAII pattern.
 *
 * It is recommended to use the convenience macros at the top
 * of this file, rather than instantiate CueStackLockObject directly.
 */
class CueStackLockObject {

private:
    id m_lock;
    bool m_preventRelocking;
    bool m_needsUnlock;

public:
    CueStackLockObject(id lock, bool preventRelocking = false, bool lockForWriting = false, bool acceptNil = false);
    ~CueStackLockObject();
};

#endif
