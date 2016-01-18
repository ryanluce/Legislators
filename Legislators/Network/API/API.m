//
//  API.m
//  Legislators
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import "API.h"

@implementation API

/**
 *  Uses a zip code to build a url to the endpoint that will return a list of legislators near that endpoint
 *
 *  @param zipCode String value of a US based zip code, i.e. 97202,06605 etc
 *
 *  @return returns an NSURL pointing to the Sunpoint api
 */
- (NSURL *)urlForLegislatorsEndPointWithZipCode:(NSString *)zipCode {
  NSString *urlString = [NSString stringWithFormat:@"%@%@",
                         kBaseURLString,
                         [self legislatorsEndpointWithZipCode:zipCode]];
  return [NSURL URLWithString:urlString];
}

/**
 *  Creates the URL to allow loading of facebook photos because the sunpoint api did not have a built in photo key in the resulting JSON
 *
 *  @param facebookID String value of a facebook ID
 *
 *  @return facebook photo url based on the facebook ID
 */
- (NSURL *)urlForFacebookPhotoWithID:(NSString *)facebookID {
  NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&width=200&height=200", facebookID];
  return [NSURL URLWithString:urlString];
}

#pragma mark - Helpers

static const NSString *kHeaderAPIValue = @"78b86418cebb49d8a7ec077b8c37de4e";

- (NSString *)legislatorsEndpointWithZipCode:(NSString *)zipCode {
  return [NSString stringWithFormat:@"/legislators/locate?zip=%@&apikey=%@", zipCode, kHeaderAPIValue];
}

@end
