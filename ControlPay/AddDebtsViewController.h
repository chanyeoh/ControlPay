//
//  AddDebtsViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/11/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuContainerViewController.h"
#import "AFHTTPRequestOperation.h"

@interface AddDebtsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *friendTableView;
    int count;
    IBOutlet UIImageView * imagePreview;
    double initialPosition;
    
    NSMutableArray *oweArray;
    NSMutableArray *debtArray;
    
    AFHTTPRequestOperation *followOperationOwe;
    
}
@property(strong,nonatomic)NSMutableArray *friendsArray;
@property(strong, nonatomic) MFSideMenuContainerViewController *container;
-(IBAction)confirmButton:(id)sender;
@end
