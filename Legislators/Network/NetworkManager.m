//
//  NetworkManager.m
//  Legislators
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import "NetworkManager.h"
#import "API.h"

@implementation NetworkManager 


/**
 *  Gets all the legislators from the sunpoint api and passes teh response to a completion block
 *
 *  @param zipCode    The zip code to query legislators from
 *  @param completion networkBlock to pass the response to
 */
- (void)loadLegislatorsNearZipCode:(NSString *)zipCode completion:(networkBlock)completion {
  NSURL *legislatorURL = [self.api urlForLegislatorsEndPointWithZipCode:zipCode];
  NSMutableURLRequest *legislatorURLRequest = [NSMutableURLRequest requestWithURL:legislatorURL];
  [legislatorURLRequest setHTTPMethod:@"GET"];
  [[self.urlSession dataTaskWithRequest:legislatorURLRequest
   completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if(completion) {
      completion(data, response, error);
    }
  }] resume];
  
}

/**
 *  Gets the facebook image given a facebook id
 *
 *  @param facebookID facebookID from the legislator model
 *  @param completion networkBlock to pass the response to/build the image from
 */
- (void)loadFacebookImageWithFacebookID:(NSString *)facebookID completion:(networkBlock)completion {
  NSParameterAssert(facebookID);
  NSURL *facebookPhotoURL = [self.api urlForFacebookPhotoWithID:facebookID];
  NSMutableURLRequest *facebookPhotoURLRequest = [NSMutableURLRequest requestWithURL:facebookPhotoURL];
  [facebookPhotoURLRequest setHTTPMethod:@"GET"];
  [[self.urlSession dataTaskWithRequest:facebookPhotoURLRequest
   completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if(completion) {
      completion(data, response, error);
    }
   }] resume];
}

#pragma mark - Accessors
/**
 *  helpful getter to either create a new urlsession or return the one already created
 *
 *  @return NSURLSession that will run all the network commands
 */
- (NSURLSession *)urlSession {
  if(_urlSession) {
    return _urlSession;
  }
  _urlSession = [self setupNetworkSession];
  return _urlSession;
}

- (API *)api {
  if(_api) {
    return _api;
  }
  
  _api = [API new];
  return _api;
}

#pragma mark - Helpers



/**
 *  Original plan was to pass in the api header for Sunpoint, but don't want to interfere with loading Facebook images, so I'll pass the sunpoint api into the url
 *
 *  @return NSURLSessionConfiguration to set the NSURLSession up with.
 */
- (NSURLSessionConfiguration *)sessionConfig {
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  return configuration;
}

/**
 *  Helper method to reset the NSURLSession to the latest headers based on a user logging in or out.
 *
 *  @return NSURLSession
 */
- (NSURLSession *)setupNetworkSession {
  NSURLSessionConfiguration *configuration = [self sessionConfig];
  return [NSURLSession sessionWithConfiguration:configuration];
}



@end
