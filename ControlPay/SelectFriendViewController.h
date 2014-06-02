//
//  SelectFriendViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/11/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddDebtsViewController.h"

@interface SelectFriendViewController : UIViewController{
    NSArray *friendArray;
    IBOutlet UITextField *amountMoney;
    IBOutlet UIImageView * imagePreview;
}
@property (strong,nonatomic)AddDebtsViewController *addDebts;
@end
