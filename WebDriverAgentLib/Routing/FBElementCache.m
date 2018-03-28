/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBElementCache.h"

#import "LRUCache.h"
#import "FBAlert.h"
#import "XCUIElement.h"
#import "XCUIElement+FBUtilities.h"

const int ELEMENT_CACHE_SIZE = 1024;

@interface FBElementCache ()
@property (atomic, strong) LRUCache *elementCache;
@end

@implementation FBElementCache

- (instancetype)init
{
  self = [super init];
  if (!self) {
    return nil;
  }
  _elementCache = [[LRUCache alloc] initWithCapacity:ELEMENT_CACHE_SIZE];
  return self;
}

- (NSString *)storeElement:(XCUIElement *)element
{
  NSString *uuid = [[NSUUID UUID] UUIDString];
  [self.elementCache setObject:element forKey:uuid];
  return uuid;
}

- (XCUIElement *)elementForUUID:(NSString *)uuid
{
  if (!uuid) {
    return nil;
  }
  XCUIElement *element = [self.elementCache objectForKey:uuid];
  [element resolve];
  return element;
}

@end
