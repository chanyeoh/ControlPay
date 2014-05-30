//
//  DebtsViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/10/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuContainerViewController.h"

@interface DebtsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *debtsTableView;
    IBOutlet UISegmentedControl *segmentControl;
    
    CGRect originalRect;
    bool start;
    NSMutableArray *debtsList;
    NSMutableArray *oweList;
    IBOutlet UIImageView * imagePreview;
 
}
-(IBAction)toggleSwitch:(id)sender;
-(IBAction)segmentChange:(id)sender;
@property(strong, nonatomic) MFSideMenuContainerViewController *container;
@end
