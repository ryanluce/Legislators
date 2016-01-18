//
//  AppCoordinator.h
//  Legislators
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kApplicationWillTerminateNotification @"com.ryanluce.test will close"
@class NetworkManager, CachingManager;
@interface AppCoordinator : NSObject


+ (instancetype)sharedCoordinator;

@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, strong) CachingManager *cachingManager;

@end
