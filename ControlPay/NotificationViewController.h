//
//  Notifications.h
//  ControlPay
//
//  Created by Avik Bag on 5/23/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *notificationTableView;
    
}

@end
