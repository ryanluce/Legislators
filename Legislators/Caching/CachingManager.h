//
//  CachingManager.h
//  Legislators
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CacheType) {
  CacheTypeArchive,
  CacheTypeCoreData
};

@class SearchResultsModel;

@interface CachingManager : NSObject

- (void)cacheSearchResults:(SearchResultsModel *)searchResults;

- (NSArray<SearchResultsModel *> *)pastSearchResultsArray;
- (BOOL)deleteSearchResults;

@end
