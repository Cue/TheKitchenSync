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

#import <Foundation/Foundation.h>

/**
 * Convenience interface for objc thread-local storage.
 *
 * A CueThreadLocal object will generate a unique key at init-time,
 * which will be used in subsequent gets and sets into the thread dictionary.
 */
@interface CueThreadLocal : NSObject

- (id)get;

- (void)set:(id)value;

- (void)remove;

@end
