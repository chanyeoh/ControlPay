//
//  AddFriendViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 4/27/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *searchFriendArray;
    IBOutlet UITableView *searchFriendTableView;
    IBOutlet UIImageView * imagePreview;

}

@end
