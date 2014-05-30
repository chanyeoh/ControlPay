//
//  SignupViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 4/12/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SignupViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UIScrollView *theScrollView;
    
    IBOutlet UITextField * fullNameTextfield;
    IBOutlet UITextField * phoneNoTextfield;
    IBOutlet UITextField * emailTextfield;
    IBOutlet UITextField * usernameTextfield;
    IBOutlet UITextField * passwordTextfield;
    IBOutlet UITextField * repeatPasswordTextfield;
    IBOutlet UIImageView * imagePreview;
    
    MBProgressHUD *HUD;
}

@property(strong, nonatomic)UITextField *activeTextField;
@end
