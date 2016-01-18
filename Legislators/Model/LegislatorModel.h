//
//  LegislatorModel.h
//  Legislators
//
//  Created by Ryan Luce on 1/16/16.
//  Copyright © 2016 Ryan Luce. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
typedef void (^imageLoadingBlock)( UIImage * _Nullable image,
                             NSError * _Nullable error);
NS_ASSUME_NONNULL_BEGIN

@interface LegislatorModel : NSObject <NSCoding>

- (nullable instancetype)initWithName:(NSString *)name andFacebookID:(nullable NSString *)facebookID;

- (void)loadImageWithCompletion:(nullable imageLoadingBlock)completion;

@property (nonatomic, copy, nullable) NSString *nameString;
@property (nonatomic, strong, nullable) UIImage *facebookImage;

NS_ASSUME_NONNULL_END

@end
