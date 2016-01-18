//
//  LegislatorModel.m
//  Legislators
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import "LegislatorModel.h"
#import "AppCoordinator.h"
#import "NetworkManager.h"

@interface LegislatorModel() {
  NSString *facebookID;
}
@end

@implementation LegislatorModel

- (instancetype)initWithName:(NSString *)name andFacebookID:(NSString *)fbID {
  self = [super init];
  if(self){
    NSParameterAssert(name);
    self.nameString = name;
    facebookID = fbID;
  }
  return self;
}

/**
 *  Loads the image if the user has a facebook id
 *
 *  @param completion completion block returning the image loaded and an error if any
 */
- (void)loadImageWithCompletion:(imageLoadingBlock)completion {
  if(self.facebookImage) {
    completion(self.facebookImage, nil);
  }
  if(!facebookID || [facebookID isEqual:[NSNull null]]) {
    NSError *noFacebookError = [NSError errorWithDomain:@"com.ryanluce.test"
                                                   code:1
                                               userInfo:@{NSLocalizedDescriptionKey : @"This legislator does not have a facebook to draw an image from"}];
    completion(nil,noFacebookError);
  }
  AppCoordinator *appCoordinator = [AppCoordinator sharedCoordinator];
  [appCoordinator.networkManager loadFacebookImageWithFacebookID:facebookID completion:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        completion(nil, error);
      });
    }

    UIImage *image = [UIImage imageWithData:data];
    dispatch_sync(dispatch_get_main_queue(), ^{
      completion(image, nil);
    });
  }];
}

#pragma mark - NSCoding

static NSString *legislatorKeyName = @"Name";
static NSString *legislatorKeyImage = @"Image";
static NSString *legislatorFacebookID = @"FacebookID";

/**
 *  When instanteated from a saved object, set the properties passed in by the decoder
 *
 *  @param aDecoder Decoder which contains our name and image
 *
 *  @return self
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if(self) {
    self.nameString = [aDecoder decodeObjectForKey:legislatorKeyName];
    self.facebookImage = [aDecoder decodeObjectForKey:legislatorKeyImage];
    facebookID = [aDecoder decodeObjectForKey:legislatorFacebookID];
  }
  return self;
}

/**
 *  Package up the data we have in order to save to disk
 *
 *  @param aCoder NSCoder to add our name and image to
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.nameString
            forKey:legislatorKeyName];
  [aCoder encodeObject:self.facebookImage
            forKey:legislatorKeyImage];
  [aCoder encodeObject:facebookID
                forKey:legislatorFacebookID];
}



@end
