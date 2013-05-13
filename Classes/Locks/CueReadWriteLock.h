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

#import <Foundation/Foundation.h>
#import "CueFairLock.h"
#import "CueThreadLocal.h"

/**
 * Cue Read/Write Lock.
 *
 * WARNING: In benchmarking, CueReadWriteLock proved to be far slower than normal or recursive locks. 
 * We are working on improving it, but in the meantime think hard about whether you want to incur this overhead.
 */
@interface CueReadWriteLock : NSObject <NSLocking, CueTestableLock>

- (void)lockForWrite;

- (void)lockForRead; // Synonym for - (void)lock;

@end
