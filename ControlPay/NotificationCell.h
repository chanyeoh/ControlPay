//
//  NotificationCell.h
//  ControlPay
//
//  Created by Avik Bag on 5/23/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel * username;
@property (strong, nonatomic) IBOutlet UILabel * notificationType;
@property (strong, nonatomic) IBOutlet UIImageView * profilePic;
@end
