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

/**
 * Lightweight class for quick insertion as a CueLoadingCache key.
 * Once inserted, the get method will call the heavyweight loading logic so as not to tie up the lock.
 */
@interface CueValueLoader : NSObject {
    NSObject *_value;
    id (^_loader)();
}

- (id)initWithBlock:(id (^)())block;

- (id)get;

- (void)set:(id)value;

@end
