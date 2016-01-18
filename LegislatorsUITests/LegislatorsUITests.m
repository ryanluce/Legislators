//
//  LegislatorsUITests.m
//  LegislatorsUITests
//
//  Created by Ryan Luce on 1/18/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface LegislatorsUITests : XCTestCase

@end

@implementation LegislatorsUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/**
 *  Test that not inputting 5 digits for zip code pops up an error
 */
- (void)testIncorrectZipCodeInput {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *zipCodeTextField = app.textFields[@"Zip Code"];
    [zipCodeTextField tap];
    [zipCodeTextField typeText:@"2"];
    [app.buttons[@"Search Legislators"] tap];
    XCUIElement *errorAlert = app.alerts[@"Error"];
    XCTAssert(errorAlert != nil, @"An error alert should have popped up.");
    [errorAlert.collectionViews.buttons[@"Ok"] tap];
    
}

@end
