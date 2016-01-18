//
//  LegislatorsTests.m
//  Legislators Sample
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CachingManager.h"
#import "NetworkManager.h"
#import "AppCoordinator.h"
#import "SearchResultsModel.h"
#import "LegislatorModel.h"
#import "SearchResultsSerializer.h"

@interface LegislatorsTests : XCTestCase {
    AppCoordinator *appCoordinator;
}

@end

@implementation LegislatorsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    appCoordinator = [AppCoordinator sharedCoordinator];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCache {
    SearchResultsModel *searchResults = [SearchResultsModel new];
    //Add dummy data
    searchResults.zipCode = @"97202";
    searchResults.legislators = @[[LegislatorModel new], [LegislatorModel new]];
    //save some data
    [appCoordinator.cachingManager cacheSearchResults:searchResults];
    NSArray *pastSearchResults = [appCoordinator.cachingManager pastSearchResultsArray];
    //Make sure there are results
    XCTAssert(pastSearchResults.count, @"Past search results should contain at least one result");
    //Make sure that deleting the results doesn't return an error
    XCTAssert([appCoordinator.cachingManager deleteSearchResults], @"Past search results weren't able to delete.");
}

- (void)testSunpointAPI {
    //Network request so we'll set the test up with an expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for the Sunpoint API to return results"];
    //Load legislators near me
    [appCoordinator.networkManager loadLegislatorsNearZipCode:@"97202"
                                                   completion:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         if(error) {
             //If there's an error log it out so I can see it.
             NSString *errorString = [NSString stringWithFormat:@"NSURLSession Error: %@", error.localizedDescription];
             NSLog(errorString);
         }
         //If there's an error fail the test
         XCTAssert(error == nil, @"NSURLSession Error");
         //If the status code isn't 200 we can infer the Sunpoint API had a problem
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         XCTAssert(httpResponse.statusCode == 200, @"Sunpoint API didn't respond with a 200");
         //If we didn't receive any data we won't be able to load the results
         XCTAssert(data != nil, @"Sunpoint API did not return data");
         //Fulfill the expectation
         [expectation fulfill];
     }];
    //Wait for an arbitrary amount of time for a response from the network call
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout while waiting for the Sunpoint API to respond: %@", error.localizedDescription);
        }
    }];
}

- (void)testFacebookImage {
    //Network request so we'll set the test up with an expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for the Facebook to return an image"];
    
    [appCoordinator.networkManager loadFacebookImageWithFacebookID:@"152754318103332"
                                                        completion:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                            if(error) {
                                                                //If there's an error log it out so I can see it.
                                                                NSString *errorString = [NSString stringWithFormat:@"NSURLSession Error: %@", error.localizedDescription];
                                                                NSLog(errorString);
                                                            }
                                                            //If there's an error fail the test
                                                            XCTAssert(error == nil, @"NSURLSession Error");
                                                            //If the status code isn't 200 we can infer the Facebook graph API had a problem
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                            XCTAssert(httpResponse.statusCode == 200, @"Facebook API didn't respond with a 200");
                                                            
                                                            //If we didn't receive any data we won't be able to load the image
                                                            XCTAssert(data != nil, @"Facebook API did not return data");
                                                            
                                                            UIImage *facebookImage = [UIImage imageWithData:data];
                                                            XCTAssert(facebookImage != nil, @"Unable to convert resulting data into an image");
                                                            //Fulfill the expectation
                                                            [expectation fulfill];
                                                        }];
    //Wait for an arbitrary amount of time for a response from the network call
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout while waiting for the Facebook API to respond: %@", error.localizedDescription);
        }
    }];
}

- (void)testSearchResultsSerialization {
    NSString *searchResultsDummyData = @"{\"results\":[{\"bioguide_id\":\"W000779\",\"birthday\":\"1949-05-03\",\"chamber\":\"senate\",\"contact_form\":\"http://www.wyden.senate.gov/contact\",\"crp_id\":\"N00007724\",\"district\":null,\"facebook_id\":null,\"fax\":\"202-228-2717\",\"fec_ids\":[\"S6OR00110\",\"H0OR03026\"],\"first_name\":\"Ron\",\"gender\":\"M\",\"govtrack_id\":\"300100\",\"icpsr_id\":14871,\"in_office\":true,\"last_name\":\"Wyden\",\"lis_id\":\"S247\",\"middle_name\":null,\"name_suffix\":null,\"nickname\":null,\"oc_email\":\"Sen.Wyden@opencongress.org\",\"ocd_id\":\"ocd-division/country:us/state:or\",\"office\":\"221 Dirksen Senate Office Building\",\"party\":\"D\",\"phone\":\"202-224-5244\",\"senate_class\":3,\"state\":\"OR\",\"state_name\":\"Oregon\",\"state_rank\":\"senior\",\"term_end\":\"2017-01-03\",\"term_start\":\"2011-01-05\",\"thomas_id\":\"01247\",\"title\":\"Sen\",\"twitter_id\":\"RonWyden\",\"votesmart_id\":27036,\"website\":\"http://www.wyden.senate.gov\",\"youtube_id\":\"senronwyden\"},{\"bioguide_id\":\"S001180\",\"birthday\":\"1951-10-19\",\"chamber\":\"house\",\"contact_form\":\"https://schrader.house.gov/contact\",\"crp_id\":\"N00030071\",\"district\":5,\"facebook_id\":\"94978896695\",\"fax\":\"202-225-5699\",\"fec_ids\":[\"H8OR05107\"],\"first_name\":\"Kurt\",\"gender\":\"M\",\"govtrack_id\":\"412315\",\"icpsr_id\":20944,\"in_office\":true,\"last_name\":\"Schrader\",\"middle_name\":null,\"name_suffix\":null,\"nickname\":null,\"oc_email\":\"Rep.Schrader@opencongress.org\",\"ocd_id\":\"ocd-division/country:us/state:or/cd:5\",\"office\":\"2431 Rayburn House Office Building\",\"party\":\"D\",\"phone\":\"202-225-5711\",\"state\":\"OR\",\"state_name\":\"Oregon\",\"term_end\":\"2017-01-03\",\"term_start\":\"2015-01-06\",\"thomas_id\":\"01950\",\"title\":\"Rep\",\"twitter_id\":\"RepSchrader\",\"votesmart_id\":10813,\"website\":\"http://schrader.house.gov\",\"youtube_id\":\"repkurtschrader\"},{\"bioguide_id\":\"B000574\",\"birthday\":\"1948-08-16\",\"chamber\":\"house\",\"contact_form\":\"https://forms.house.gov/blumenauer/webforms/issue_subscribe.html\",\"crp_id\":\"N00007727\",\"district\":3,\"facebook_id\":null,\"fax\":\"202-225-8941\",\"fec_ids\":[\"H6OR03064\"],\"first_name\":\"Earl\",\"gender\":\"M\",\"govtrack_id\":\"400033\",\"icpsr_id\":29588,\"in_office\":true,\"last_name\":\"Blumenauer\",\"middle_name\":null,\"name_suffix\":null,\"nickname\":null,\"oc_email\":\"Rep.Blumenauer@opencongress.org\",\"ocd_id\":\"ocd-division/country:us/state:or/cd:3\",\"office\":\"1111 Longworth House Office Building\",\"party\":\"D\",\"phone\":\"202-225-4811\",\"state\":\"OR\",\"state_name\":\"Oregon\",\"term_end\":\"2017-01-03\",\"term_start\":\"2015-01-06\",\"thomas_id\":\"00099\",\"title\":\"Rep\",\"twitter_id\":\"BlumenauerMedia\",\"votesmart_id\":367,\"website\":\"http://blumenauer.house.gov\",\"youtube_id\":\"RepBlumenauer\"},{\"bioguide_id\":\"M001176\",\"birthday\":\"1956-10-24\",\"chamber\":\"senate\",\"contact_form\":\"http://www.merkley.senate.gov/contact/\",\"crp_id\":\"N00029303\",\"district\":null,\"facebook_id\":\"74374931545\",\"fax\":\"202-228-3997\",\"fec_ids\":[\"S8OR00207\"],\"first_name\":\"Jeff\",\"gender\":\"M\",\"govtrack_id\":\"412325\",\"icpsr_id\":40908,\"in_office\":true,\"last_name\":\"Merkley\",\"lis_id\":\"S322\",\"middle_name\":null,\"name_suffix\":null,\"nickname\":null,\"oc_email\":\"Sen.Merkley@opencongress.org\",\"ocd_id\":\"ocd-division/country:us/state:or\",\"office\":\"313 Hart Senate Office Building\",\"party\":\"D\",\"phone\":\"202-224-3753\",\"senate_class\":2,\"state\":\"OR\",\"state_name\":\"Oregon\",\"state_rank\":\"junior\",\"term_end\":\"2021-01-03\",\"term_start\":\"2015-01-06\",\"thomas_id\":\"01900\",\"title\":\"Sen\",\"twitter_id\":\"SenJeffMerkley\",\"votesmart_id\":23644,\"website\":\"http://www.merkley.senate.gov\",\"youtube_id\":\"SenatorJeffMerkley\"}],\"count\":4,\"page\":{\"count\":4,\"per_page\":20,\"page\":1}}";
    
    SearchResultsModel *searchResults = [SearchResultsSerializer serializeSearchResults:[searchResultsDummyData dataUsingEncoding:NSUTF8StringEncoding]
                                                                                zipCode:@"97202"];
    XCTAssert(searchResults.legislators.count == 4, @"Search results model does not contain the 4 legislators present in the data");
    XCTAssert([searchResults.zipCode isEqualToString:@"97202"], @"Search results model does not contain the passed in zip code");
    
}



@end
