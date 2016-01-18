//
//  AppCoordinator.m
//  Legislators
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import "AppCoordinator.h"
#import "NetworkManager.h"
#import "CachingManager.h"

@implementation AppCoordinator

- (instancetype)init {
  self = [super init];
  if(self) {
    self.networkManager = [NetworkManager new];
    self.cachingManager = [CachingManager new];
  }
  return self;
}

#pragma mark static methods
/**
 *  Get the single app coordinator.
 *
 *  @return the single instance of this class
 */
+ (instancetype)sharedCoordinator {
  static id sharedCoordinator;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedCoordinator = [self new];
  });
  return sharedCoordinator;
}

@end
