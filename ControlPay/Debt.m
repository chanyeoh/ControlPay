//
//  Debt.m
//  ControlPay
//
//  Created by Yeoh Chan on 5/17/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "Debt.h"

@implementation Debt
@synthesize id;

@synthesize debtAmount;
@synthesize friendName;

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.id = [decoder decodeObjectForKey:@"id"];
        
        self.debtAmount = [decoder decodeObjectForKey:@"debtAmount"];
        self.friendName = [decoder decodeObjectForKey:@"friendName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:id forKey:@"id"];
    
    [encoder encodeObject:debtAmount forKey:@"debtAmount"];
    [encoder encodeObject:friendName forKey:@"friendName"];
}


-(void)updateContext:(NSDictionary *)dictionary{
    self.id = [dictionary objectForKey:@"id"];
    
    self.debtAmount = [dictionary objectForKey:@"debtAmount"];
    self.friendName = [[dictionary objectForKey:@"friendProfile"] objectForKey:@"fullName"];
}

@end
