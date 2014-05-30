//
//  AcceptFriendViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 4/29/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcceptFriendViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *pendingTableView;
    NSMutableArray *pendingFriends;
}

@end
