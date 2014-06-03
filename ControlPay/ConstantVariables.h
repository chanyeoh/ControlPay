//
//  ConstantVariables.h
//  ControlPay
//
//  Created by Yeoh Chan on 4/12/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL @"http://1-dot-controlpaydrexel.appspot.com/rest/"

#define LOGIN_URL @"account/login"
#define REGISTER_URL @"account/addaccount"
#define GET_URL @"account/getAccount"
#define CHANGE_PASSWORD @"account/changePassword"
#define UPDATE_PROFILE @"account/uploadProfileImage"
#define GET_BASIC @"account/getbasics"

#define GET_FRIENDS_URL @"friends/getFriendsList"
#define SEARCH_PHONE_URL @"friends/getPhoneNumber"
#define SEARCH_USER_URL @"friends/getUsername"
#define ADD_FRIENDS_URL @"friends/addFriends"
#define ACCEPT_FRIENDS_URL @"friends/accept"

#define ADD_EXPENDITURE @"expenditures/add"
#define GET_EXPENDITURE @"expenditures/getExpenditure"

#define ADD_INCOME @"income/add"

#define ADD_DEBTS @"debts/addDebt"
#define GET_DEBTS @"debts/getDebt"
#define OWE_DEBTS @"debts/getOwe"

#define NOTIFICATION_URL @"notification/getnotification"

@interface ConstantVariables : NSObject

@end
