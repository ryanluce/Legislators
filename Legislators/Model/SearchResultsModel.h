//
//  SearchResultsModel.h
//  Legislators
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LegislatorModel;

@interface SearchResultsModel : NSObject <NSCoding>

@property (nonatomic, strong) NSArray<LegislatorModel *> *legislators;
@property (nonatomic, copy) NSString *zipCode;

@end
