//
//  SearchResultsSerializer.h
//  Legislators
//
//  Created by Ryan Luce on 1/17/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SearchResultsModel;
@interface SearchResultsSerializer : NSObject

+ (nullable SearchResultsModel *)serializeSearchResults:(nonnull NSData *)results zipCode:(nonnull NSString *)zipCode;

@end
