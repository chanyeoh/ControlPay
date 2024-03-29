//
//  SideBarViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 4/10/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuContainerViewController.h"

@interface SideBarViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *sideBarTableView;
    NSArray *sideBarArray;
    NSMutableArray *viewControllerArray;
    IBOutlet UIImageView * imagePreview;
    IBOutlet UIButton *logOut;
    IBOutlet UIButton *resetPass;
}

@property(strong, nonatomic)MFSideMenuContainerViewController *sidemenuContainer;

@end
