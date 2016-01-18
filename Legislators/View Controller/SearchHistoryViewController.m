//
//  SearchHistoryViewController.m
//  Legislators
//
//  Created by Ryan Luce on 1/17/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import "SearchHistoryViewController.h"
#import "SearchResultsViewController.h"
#import "CachingManager.h"
#import "AppCoordinator.h"
#import "SearchResultsModel.h"

@interface SearchHistoryViewController ()<UITableViewDelegate, UITableViewDataSource> {
  IBOutlet UITableView *tableview;
  CachingManager *cachingManager;
}

@end

@implementation SearchHistoryViewController

- (void)awakeFromNib {
  cachingManager = [AppCoordinator sharedCoordinator].cachingManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Let view state dictate when I update content.
 *
 */
- (void)viewWillAppear:(BOOL)animated {
  [tableview reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  NSIndexPath *indexPathForSelectedCell = [tableview indexPathForCell:(UITableViewCell *)sender];
  SearchResultsViewController *searchResultsViewController = (SearchResultsViewController *)segue.destinationViewController;
  searchResultsViewController.searchResults = cachingManager.pastSearchResultsArray[indexPathForSelectedCell.row];
}

#pragma mark - TableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return cachingManager.pastSearchResultsArray.count;
}

static NSString *reuseIdentifier = @"searchHistoryCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cellToReturn = [tableview dequeueReusableCellWithIdentifier:reuseIdentifier];
  SearchResultsModel *searchResults = cachingManager.pastSearchResultsArray[indexPath.row];
  cellToReturn.textLabel.text = [NSString stringWithFormat:@"Previous search for zip code: %@",searchResults.zipCode];
  
  return cellToReturn;
}


@end
