//
//  ProfileViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/17/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuContainerViewController.h"

@interface ProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIBarButtonItem *notificationBarButton;
    IBOutlet UIImageView * imagePreview;
    IBOutlet UIImageView * profilePic;
    IBOutlet UIButton * addExpenses;
    IBOutlet UIButton * addIncomes;

    
}
-(IBAction)toggleSwitch:(id)sender;
@property(strong, nonatomic) MFSideMenuContainerViewController *container;

@end
