//
//  Account.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/17/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject<NSCoding>
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *status;

@property (copy, nonatomic) NSString *fullName;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *phoneNo;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *displayPicture;
@property (copy, nonatomic) NSString *university;

-(void)updateContext:(NSDictionary *)dictionary;
@end
