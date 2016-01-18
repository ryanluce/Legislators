//
//  SearchResultsTableViewCell.h
//  Legislators
//
//  Created by Ryan Luce on 1/17/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LegislatorModel;

@interface SearchResultsTableViewCell : UITableViewCell

- (void)updateWithLegislator:(LegislatorModel *)legislatorModel;

@end
