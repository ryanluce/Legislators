//
//  API.h
//  Legislators
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBaseURLString @"https://congress.api.sunlightfoundation.com"

@interface API : NSObject

- (NSURL *)urlForLegislatorsEndPointWithZipCode:(NSString *)zipCode;
- (NSURL *)urlForFacebookPhotoWithID:(NSString *)facebookID;

@end
