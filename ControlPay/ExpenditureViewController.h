//
//  ExpenditureViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/9/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieView.h"
#import "MFSideMenuContainerViewController.h"

@interface ExpenditureViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSArray *expenditureArray;
    IBOutlet PieView *pieView;
    IBOutlet UIImageView * imagePreview;
}
-(IBAction)toggleSwitch:(id)sender;
@property(strong, nonatomic) MFSideMenuContainerViewController *container;
@end
