//
//  SearchResultsModel.m
//  Legislators
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import "SearchResultsModel.h"

@implementation SearchResultsModel

static NSString *searchResultsKeyLegislators = @"Legislators";
static NSString *searchResultsKeyZipCode = @"ZipCode";


/**
 *  When instanteated from a saved object, set the properties passed in by the decoder
 *
 *  @param aDecoder Decoder which contains our legislators and the zip code
 *
 *  @return self
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if(self) {
    self.legislators = [aDecoder decodeObjectForKey:searchResultsKeyLegislators];
    self.zipCode = [aDecoder decodeObjectForKey:searchResultsKeyZipCode];
  }
  return self;
}

/**
 *  Package up the data we have in order to save to disk
 *
 *  @param aCoder NSCoder to add our legislators and zip code to
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
  
  [aCoder encodeObject:self.legislators
            forKey:searchResultsKeyLegislators];
  [aCoder encodeObject:self.zipCode
            forKey:searchResultsKeyZipCode];
}

@end
