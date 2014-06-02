//
//  LoansViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 4/10/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomesViewController : UIViewController{
    IBOutlet UITextField *amountTextfield;
    IBOutlet UIImageView *imagePreview;
    IBOutlet UIButton *addIncomes;
}

-(IBAction)addLoan:(id)sender;
@end
