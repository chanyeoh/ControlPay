//
//  Expenditure.m
//  ControlPay
//
//  Created by Yeoh Chan on 5/17/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "Expenditure.h"

@implementation Expenditure
@synthesize id;
@synthesize accountid;

@synthesize category;
@synthesize message;
@synthesize amount;

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.accountid = [decoder decodeObjectForKey:@"accountid"];
        
        self.category = [decoder decodeObjectForKey:@"category"];
        self.message = [decoder decodeObjectForKey:@"message"];
        self.amount = [decoder decodeObjectForKey:@"amount"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:id forKey:@"id"];
    [encoder encodeObject:accountid forKey:@"accountid"];
    
    [encoder encodeObject:category forKey:@"category"];
    [encoder encodeObject:message forKey:@"message"];
    [encoder encodeObject:amount forKey:@"amount"];
}


-(void)updateContext:(NSDictionary *)dictionary{
    self.id = [dictionary objectForKey:@"id"];
    self.accountid = [dictionary objectForKey:@"accountid"];
    
    self.category = [dictionary objectForKey:@"category"];
    self.message = [dictionary objectForKey:@"message"];
    self.amount = [dictionary objectForKey:@"amount"];
}

-(NSDictionary *)toDictionary{
    return [[NSDictionary alloc] initWithObjectsAndKeys: self.accountid, @"accountId", self.category, @"category", self.amount, @"amount", nil];
}
@end
