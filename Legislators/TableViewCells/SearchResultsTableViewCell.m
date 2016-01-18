//
//  SearchResultsTableViewCell.m
//  Legislators
//
//  Created by Ryan Luce on 1/17/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import "SearchResultsTableViewCell.h"
#import "LegislatorModel.h"

@interface SearchResultsTableViewCell () {
  IBOutlet UIImageView *faceImageView;
  IBOutlet UILabel *nameLabel;
  LegislatorModel *legislator;
}
@end

@implementation SearchResultsTableViewCell

- (void)updateWithLegislator:(LegislatorModel *)legislatorModel {
  legislator = legislatorModel;
  nameLabel.text = legislator.nameString;
  if(legislator.facebookImage) {
    faceImageView.image = legislator.facebookImage;
  } else {
    faceImageView.image = [UIImage imageNamed:@"noImage"];
    [legislator loadImageWithCompletion:^(UIImage * _Nullable image, NSError * _Nullable error) {
      if(image) {
        faceImageView.image = image;
      }
    }];
  }
}

@end
