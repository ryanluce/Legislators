//
//  SearchViewController.m
//  Legislators
//
//  Created by Ryan Luce on 1/17/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultsViewController.h"
#import "SearchResultsModel.h"
#import "AppCoordinator.h"
#import "NetworkManager.h"
#import "CachingManager.h"
#import "SearchResultsSerializer.h"


@interface SearchViewController () <UITextFieldDelegate> {
  IBOutlet UITextField *searchQueryTextField;
  IBOutlet UIView *activityHUDView;
  SearchResultsModel *searchResults;
  
}

@end

@implementation SearchViewController

- (void)awakeFromNib {
  //Always want to save the last search
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(cacheSearchResults)
                                               name:kApplicationWillTerminateNotification
                                             object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  //Better uix to have hte keyboard show right away.
  [searchQueryTextField becomeFirstResponder];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Navigation
static NSString *segueSearchResultsIdentifier = @"searchToSearchResultsSegue";
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  //Update the results view controller with the zip code to search
  SearchResultsViewController *searchResultsViewController = segue.destinationViewController;
  [searchResultsViewController setSearchResults:searchResults];
}

- (IBAction)searchButtonPressed:(id)sender {
  [self loadSearchResultsWithZipCode:searchQueryTextField.text];
}

#pragma mark - Textfield

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self loadSearchResultsWithZipCode:textField.text];
  return YES;
}

#pragma mark - Helpers 

- (void)loadSearchResultsWithZipCode:(nullable NSString *)zipCode {
  if(zipCode.length != 5) {
    [self showError:@"Zip code should contain 5 numbers for optimal results"];
    return;
  }
  AppCoordinator *appCoordinator = [AppCoordinator sharedCoordinator];
  
  [self showActivityIndicator];
  //Save the last
  if(searchResults) {
    [appCoordinator.cachingManager cacheSearchResults:searchResults];
    searchResults = nil;
  }

  [appCoordinator.networkManager loadLegislatorsNearZipCode:zipCode
    completion:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      //Check for errors
      NSString *errorString = nil;
      if(error) {
        errorString = error.localizedDescription;
      }
      
      SearchResultsModel *newSearchResults;
      if(!errorString && !data) {
        errorString = @"No data was returned.";
      } else if(!errorString) {
        newSearchResults = [SearchResultsSerializer serializeSearchResults:data
                                                                   zipCode:zipCode];
      }
      if(!errorString && !newSearchResults.legislators.count) {
        errorString = @"No legislators returned for that zip code";
      }
      
      if(errorString) {
        dispatch_sync(dispatch_get_main_queue(), ^{
          [self hideActivityIndicator];
          [self showError:errorString];
        });
        return;
      }
      //Back on the main thread
      dispatch_sync(dispatch_get_main_queue(), ^{
        [self cacheSearchResults];
        searchResults = newSearchResults;
        [self hideActivityIndicator];
        [self performSegueWithIdentifier:segueSearchResultsIdentifier sender:self];
      });
      
    }];
}
/**
 *  Caches the search results. Done on a new search and on dealloc to help bring as many legislator images(from facebook) into the archiving process, resulting in better performance.
 */
- (void)cacheSearchResults {
  //Save the last search
  if(searchResults) {
    AppCoordinator *appCoordinator = [AppCoordinator sharedCoordinator];
    [appCoordinator.cachingManager cacheSearchResults:searchResults];
    searchResults = nil;
  }
}

/**
 *  Pops up an error dialog to alert the user something went wrong.
 *
 *  @param errorDescription text to put into the body of the alert
 */
- (void)showError:(NSString *)errorDescription {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:errorDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  //Alert will retain the block so use weakSelf
  __weak __typeof__(self) weakSelf = self;
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                     [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                   }];
  [alertController addAction:okAction];
  [self presentViewController:alertController
                     animated:YES
                   completion:nil];
}

/**
 *  Show and hide an activity indicator to alert the user that the application is doing something in the background
 */
- (void)showActivityIndicator {
  activityHUDView.hidden = NO;
  [UIView animateWithDuration:.2
                   animations:^{
                     activityHUDView.alpha = 1.f;
                   }];
}

- (void)hideActivityIndicator {
  activityHUDView.alpha = 0;
  activityHUDView.hidden = YES;
  searchQueryTextField.text = @"";
}

@end
