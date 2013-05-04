//
//  CueStackLock
//  Cue
//
//  Created by Aaron Sarazan on 7/9/12.
//  Copyright 2012 Cue, Inc. All rights reserved.
//
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
