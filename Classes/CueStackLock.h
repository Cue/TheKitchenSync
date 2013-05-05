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

#pragma once

#ifdef __cplusplus
class CueStackLockObject {

private:
    id m_lock;
    bool m_preventRelocking;
    bool m_needsUnlock;

public:
    CueStackLockObject(id lock, bool preventRelocking = false, bool lockForWriting = false, bool acceptNil = false);
    ~CueStackLockObject();
};


#define CueStackLock(__lockable__) \
CueStackLockObject __stackLock_##__lockable__(__lockable__)

#define CueStackLockIfSet(__lockable__) \
CueStackLockObject __stackLock_##__lockable__(__lockable__, false, false, true)

#define CueStackLockWrite(__lockable__) \
CueStackLockObject __stackLock_##__lockable__(__lockable__, false, true)

#define CueStackLockNoRelock(__lockable__) \
CueStackLockObject __stackLock_##__lockable__(__lockable__, true)

#endif
