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

#import "CueStackLock.h"
#import "CueSyncCollections.h"

#include <mutex>

#ifndef TheKitchenSync_CueSyncCollectionsPriv_h
#define TheKitchenSync_CueSyncCollectionsPriv_h

#define READ_TYPE(__type__, ...) \
__block __type__ retval; \
dispatch_sync(_queue, ^{ \
retval = __VA_ARGS__; \
}); \
return retval

#define READ_ID(...) \
READ_TYPE(id, __VA_ARGS__)

#define READ(...) \
dispatch_sync(_queue, ^{ \
__VA_ARGS__; \
});

#define WRITE(...) \
dispatch_barrier_sync(_queue, ^{ \
__VA_ARGS__; \
});

#endif
