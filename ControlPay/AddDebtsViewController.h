//
//  AddDebtsViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/11/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDebtsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *friendTableView;
    int count;
    IBOutlet UIImageView * imagePreview;
    
}
@property(strong,nonatomic)NSMutableArray *friendsArray;
-(IBAction)confirmButton:(id)sender;
@end
