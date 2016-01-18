//
//  SearchResultsViewController.h
//  Legislators
//
//  Created by Ryan Luce on 1/17/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResultsModel;
@interface SearchResultsViewController : UIViewController

@property (nullable, nonatomic, strong) SearchResultsModel *searchResults;

@end
