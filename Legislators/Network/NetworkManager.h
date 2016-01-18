//
//  NetworkManager.h
//  Legislators
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^networkBlock)( NSData * _Nullable data,
                              NSURLResponse  * _Nullable response,
                              NSError * _Nullable error);
@class API;
@interface NetworkManager : NSObject

- (void)loadLegislatorsNearZipCode:(nonnull NSString *)zipCode completion:(nullable networkBlock)completion;
- (void)loadFacebookImageWithFacebookID:(nonnull NSString *)facebookID completion:(nullable networkBlock)completion;

@property (nonatomic, strong, nullable) NSURLSession *urlSession;
@property (nonatomic, strong, nullable) API *api;
@end
