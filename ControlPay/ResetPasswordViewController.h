//
//  ResetPasswordViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/23/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController{
    IBOutlet UITextField *currPassword;
    IBOutlet UITextField * newPassword;
    IBOutlet UITextField *confirmNewPassword;
}

@end
