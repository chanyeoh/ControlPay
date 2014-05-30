//
//  Account.m
//  ControlPay
//
//  Created by Yeoh Chan on 5/17/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "Friend.h"

@implementation Friend
@synthesize id;
@synthesize status;

@synthesize fullName;
@synthesize username;
@synthesize phoneNo;
@synthesize email;
@synthesize displayPicture;
@synthesize university;

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.id = [decoder decodeObjectForKey:@"friendId"];
        self.status = [decoder decodeObjectForKey:@"status"];
        
        self.fullName = [decoder decodeObjectForKey:@"fullName"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.phoneNo = [decoder decodeObjectForKey:@"phoneNo"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.displayPicture = [decoder decodeObjectForKey:@"displayPicture"];
        self.university = [decoder decodeObjectForKey:@"university"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:id forKey:@"friendId"];
    [encoder encodeObject:status forKey:@"status"];
    
    
    [encoder encodeObject:fullName forKey:@"fullName"];
    [encoder encodeObject:username forKey:@"username"];
    [encoder encodeObject:phoneNo forKey:@"phoneNo"];
    [encoder encodeObject:email forKey:@"email"];
    [encoder encodeObject:displayPicture forKey:@"displayPicture"];
    [encoder encodeObject:university forKey:@"university"];
}


-(void)updateContext:(NSDictionary *)dictionary{
    self.id = [dictionary objectForKey:@"friendId"];
    self.status = [dictionary objectForKey:@"status"];
    
    NSDictionary *friendInfoDict = [dictionary objectForKey:@"frienAccount"];
    self.fullName = [friendInfoDict objectForKey:@"fullName"];
    self.username = [friendInfoDict objectForKey:@"username"];
    self.phoneNo = [friendInfoDict objectForKey:@"phoneNo"];
    self.email = [friendInfoDict objectForKey:@"email"];
    self.displayPicture = [friendInfoDict objectForKey:@"displayPicture"];
    self.university = [friendInfoDict objectForKey:@"university"];
}

@end
