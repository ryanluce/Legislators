//
//  CachingManager.m
//  Legislators
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import "CachingManager.h"
#import "SearchResultsModel.h"

@interface CachingManager() {
  NSArray <SearchResultsModel *> *_pastSearchResultsArray;
}
@end

@implementation CachingManager

/**
 *  Saves a new set of search results to disk
 *
 *  @param searchResults the model to add to the cache
 */
- (void)cacheSearchResults:(SearchResultsModel *)searchResults {
  __block BOOL alreadyContainsZipCode = NO;
  [self.pastSearchResultsArray enumerateObjectsUsingBlock:^(SearchResultsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //Search for the same zip code in the past results
    if([obj.zipCode isEqualToString:searchResults.zipCode]) {
      alreadyContainsZipCode = YES;
    }
  }];
  //Don't add copies.
  if(alreadyContainsZipCode) {
    return;
  }
  //Create a copy of the existing array that is able to add objects to
  NSMutableArray <SearchResultsModel *> *mutablePastSearchResults = [self.pastSearchResultsArray mutableCopy];
  [mutablePastSearchResults addObject:searchResults];
  //reset the pastSearchResultsArray
  _pastSearchResultsArray = [NSArray arrayWithArray:mutablePastSearchResults];
  //Archive to disk
  [self archivePastSearchResults];
}

/**
 *  An easy way to get all the search resultsl
 *
 *  @return An array of all previous search results
 */
- (NSArray<SearchResultsModel *> *)pastSearchResultsArray {
  if(!_pastSearchResultsArray) {
    [self loadPastSearchResults];
  }
  return _pastSearchResultsArray;
}

/**
 *  Removes all search results
 *
 *  @return YES if the file was successfully deleted
 */
- (BOOL)deleteSearchResults {
  _pastSearchResultsArray = @[];
  NSFileManager *fileManager = [NSFileManager new];
  NSError *error;
  BOOL deleteSuccessful = [fileManager removeItemAtPath:[self filePathToSearchResults]
                                                  error:&error];
  if(error) {
    NSLog(@"Error deleting search results: %@", [error description]);
  }
  return deleteSuccessful;
}

#pragma mark - Helpers
/**
 *  Overwrite the existing saved search results with the current batch.
 */
- (void)archivePastSearchResults {
  if(_pastSearchResultsArray) {
    [NSKeyedArchiver archiveRootObject:_pastSearchResultsArray
                                toFile:[self filePathToSearchResults]];
  }
}

/**
 *  Load all the past search results from disk
 */
- (void)loadPastSearchResults {
  _pastSearchResultsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePathToSearchResults]];
  if(!_pastSearchResultsArray) {
    _pastSearchResultsArray = @[];
  }
}


static NSString *archivedObjectName = @"SearchResults";

- (NSString *)filePathToSearchResults {
  NSArray<NSString *> *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *basePath = pathsArray[0];
  return [basePath stringByAppendingPathComponent:archivedObjectName];
}

@end
