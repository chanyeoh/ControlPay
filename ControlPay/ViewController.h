//
//  ViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 4/10/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UIScrollView *theScrollView;
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *passwordTextField;
    
    
    IBOutlet UIButton * login;
    IBOutlet UIButton * signup;
    IBOutlet UIImageView * imagePreview;
}

-(IBAction)loginClick:(id)sender;

@property(strong, nonatomic)UITextField *activeTextField;
@end
