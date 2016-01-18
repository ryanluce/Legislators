//
//  SearchResultsSerializer.m
//  Legislators
//
//  Created by Ryan Luce on 1/17/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import "SearchResultsSerializer.h"
#import "SearchResultsModel.h"
#import "LegislatorModel.h"
@implementation SearchResultsSerializer

static NSString *searchResultsKey = @"results";
static const NSString *legislatorKeyFirstName = @"first_name";
static const NSString *legislatorKeyLastName = @"last_name";
static const NSString *legislatorKeyFacebookID = @"facebook_id";
/**
 *  Packages up raw json data into SearchResults and Legislator models
 *
 *  @param results raw nsdata result from the api
 *  @param zipCode zip code that was searched
 *
 *  @return SearchResultsModel containing rich Legislator models and the passed in Zip Code
 */
+ (SearchResultsModel *)serializeSearchResults:(NSData *)results zipCode:(NSString *)zipCode {
  //Can't go further without results
  NSParameterAssert(results);
  
  //TODO: Pass in an error instead of throwing an exception if serialization fails
  NSError *error;
  NSDictionary <NSString *, id> *resultsDictionary = [NSJSONSerialization JSONObjectWithData:results
                                                                                     options:0
                                                                                       error:&error];
  NSArray<NSDictionary *> *rawResultsArray = resultsDictionary[searchResultsKey];
  
  if(error) {
    NSLog(@"Error: %@", error.description);
    NSException *exception = [NSException exceptionWithName:@"Error Serializing data"
                                                     reason:error.localizedDescription
                                                   userInfo:nil];
    @throw exception;
  }
  //Iterate through results and build out rich models
  NSMutableArray *searchResultsArray = [NSMutableArray array];
  [rawResultsArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSString *legislatorName = [NSString stringWithFormat:@"%@ %@", obj[legislatorKeyFirstName], obj[legislatorKeyLastName]];
    LegislatorModel *legislatorToAdd = [[LegislatorModel alloc] initWithName:legislatorName
                                                               andFacebookID:obj[legislatorKeyFacebookID]];
    [searchResultsArray addObject:legislatorToAdd];
  }];
  
  SearchResultsModel *searchResults = [SearchResultsModel new];
  searchResults.legislators = [NSArray arrayWithArray:searchResultsArray];
  searchResults.zipCode = zipCode;
  return searchResults;
}

@end
