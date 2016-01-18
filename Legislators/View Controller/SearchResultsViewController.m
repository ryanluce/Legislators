//
//  SearchResultsViewController.m
//  Legislators
//
//  Created by Ryan Luce on 1/17/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "SearchResultsModel.h"
#import "SearchResultsTableViewCell.h"

@interface SearchResultsViewController () <UITableViewDataSource, UITableViewDelegate> {
  IBOutlet UITableView *tableview;
}

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors 
- (void)setSearchResults:(SearchResultsModel *)searchResults {
  _searchResults = searchResults;
  self.title = [NSString stringWithFormat:@"Search results for %@", searchResults.zipCode];
  [tableview reloadData];
}

#pragma mark - tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if(self.searchResults) {
    return self.searchResults.legislators.count;
  }
  return 0;
}

static NSString *reuseIdentifier = @"legislatorCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SearchResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
#warning should check here if the array has a model at this index, but assuming it does.
    SearchResultsTableViewCell *cellToUpdate = (SearchResultsTableViewCell *)cell;
    [cellToUpdate updateWithLegislator:self.searchResults.legislators[indexPath.row]];
}
@end
