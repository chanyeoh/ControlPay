//
//  FriendsViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 4/12/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuContainerViewController.h"

@interface FriendsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *friendTableView;
    IBOutlet UIBarButtonItem *pendingButton;
    NSMutableArray *friendsArray;
    NSString *myStatus;
    IBOutlet UISegmentedControl * segmentControl;
    IBOutlet UIImageView * imagePreview;

}
-(IBAction)segmentValueChanged:(id)sender;
-(IBAction)toggleSwitch:(id)sender;
@property(strong, nonatomic) MFSideMenuContainerViewController *container;
@end
