//
//  Debt.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/17/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Debt : NSObject<NSCoding>
@property(copy, nonatomic) NSString *id;

@property(copy, nonatomic) NSString *debtAmount;
@property(copy, nonatomic) NSString *friendName;

-(void)updateContext:(NSDictionary *)dictionary;
-(void)updateContextReverse:(NSDictionary *)dictionary;
@end
