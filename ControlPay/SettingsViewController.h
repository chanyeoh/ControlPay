//
//  SettingsViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/12/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuContainerViewController.h"
#import "ResetPasswordViewController.h"

@interface SettingsViewController : UITableViewController{
    NSArray *settingsArray;
    ResetPasswordViewController *resetViewController;
}
-(IBAction)toggleSwitch:(id)sender;
@property(strong, nonatomic) MFSideMenuContainerViewController *container;

@end
