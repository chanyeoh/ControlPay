//
//  Expenditure.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/17/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expenditure : NSObject<NSCoding>
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *accountid;

@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *amount;

-(void)updateContext:(NSDictionary *)dictionary;
-(NSDictionary *)toDictionary;
@end
