//
//  SignupViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 4/12/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "SignupViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "backgroundDesignViewController.h"
#import "UIImage+StackBlur.h"

#import "ConstantVariables.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [theScrollView setContentSize:self.view.frame.size];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapDetector:)];
    singleTap.cancelsTouchesInView=NO;
    [singleTap setNumberOfTapsRequired:1];
    
    [theScrollView addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                            selector:@selector(keyboardWasShown:)
                                            name:UIKeyboardDidShowNotification
                                            object:nil];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                            name:UIKeyboardWillHideNotification
                                            object:nil];
    
    //self.view.backgroundColor = [UIColor whiteColor];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[backgroundDesignViewController blur:1.5f withImage:[UIImage imageNamed:@"wallpapers5.jpg"]]];    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    imagePreview.image=[[UIImage imageNamed:@"singaporeSkyline2.jpg"] stackBlur:5];

    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor cyanColor]];
    
    fullNameTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    phoneNoTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"U.S. only Ph.No." attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    emailTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"johndoe@domain.com" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    usernameTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    repeatPasswordTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Repeat Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Signup Detect
-(IBAction)signupAccount:(id)sender{
    
    // TODO Check Password is matching & Textfields are not empty
    NSArray * indvidualElementsCheck = [[NSArray alloc]initWithObjects:fullNameTextfield.text,phoneNoTextfield.text,emailTextfield.text,usernameTextfield.text,passwordTextfield.text,repeatPasswordTextfield.text, nil];
    
    NSInteger i = [indvidualElementsCheck indexOfObject:@""];
    if ([indvidualElementsCheck containsObject:@""] && i == 0) {
        UIAlertView * missingValues = [[UIAlertView alloc]initWithTitle:@"Error Signing Up" message:@"Elements Missing: Name Input" delegate:nil cancelButtonTitle:@"Redo!" otherButtonTitles:nil, nil];
        [missingValues show];
    }
    if ([indvidualElementsCheck containsObject:@""] && i == 1) {
        UIAlertView * missingValues = [[UIAlertView alloc]initWithTitle:@"Error Signing Up" message:@"Elements Missing: Phone Input" delegate:nil cancelButtonTitle:@"Redo!" otherButtonTitles:nil, nil];
        [missingValues show];
    }
        
    if ([indvidualElementsCheck containsObject:@""] && i == 2) {
        UIAlertView * missingValues = [[UIAlertView alloc]initWithTitle:@"Error Signing Up" message:@"Elements Missing: Email Input" delegate:nil cancelButtonTitle:@"Redo!" otherButtonTitles:nil, nil];
        [missingValues show];
    }
    if ([indvidualElementsCheck containsObject:@""] && i == 3) {
        UIAlertView * missingValues = [[UIAlertView alloc]initWithTitle:@"Error Signing Up" message:@"Elements Missing: Username Input" delegate:nil cancelButtonTitle:@"Redo!" otherButtonTitles:nil, nil];
        [missingValues show];
    }
    if ([indvidualElementsCheck containsObject:@""] && i == 4) {
        UIAlertView * missingValues = [[UIAlertView alloc]initWithTitle:@"Error Signing Up" message:@"Elements Missing: Password Input" delegate:nil cancelButtonTitle:@"Redo!" otherButtonTitles:nil, nil];
        [missingValues show];
    }
    if ([indvidualElementsCheck containsObject:@""] && i == 5) {
        UIAlertView * missingValues = [[UIAlertView alloc]initWithTitle:@"Error Signing Up" message:@"Elements Missing: Repeat Password Input" delegate:nil cancelButtonTitle:@"Redo!" otherButtonTitles:nil, nil];
        [missingValues show];
    }
    
    else if([indvidualElementsCheck containsObject:@""] == false){
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.labelText = @"Loading...";
        [self signupToServer];
    }
}

-(void)signupToServer{
    [_activeTextField resignFirstResponder];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:fullNameTextfield.text, @"fullName",
                                phoneNoTextfield.text, @"phoneNo", emailTextfield.text, @"email", usernameTextfield.text, @"username", passwordTextfield.text, @"password", nil];
    NSURL *url = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient postPath:REGISTER_URL parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        [HUD hide:YES afterDelay:0.5];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Server Response" message:[dictionary objectForKey:@"message"] delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES afterDelay:0.5];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed to Connect" message:@"Failed to Connect to Server, please check your internet connection" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }];
}

#pragma mark -
#pragma mark UIScrollView Hide
- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Step 1: Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    theScrollView.contentInset = contentInsets;
    theScrollView.scrollIndicatorInsets = contentInsets;
    
    
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect, _activeTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, _activeTextField.frame.origin.y - (keyboardSize.height-15));
        [theScrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    theScrollView.contentInset = contentInsets;
    theScrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeTextField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_activeTextField resignFirstResponder];
    _activeTextField = nil;
}

- (IBAction)dismissKeyboard:(id)sender
{
    [_activeTextField resignFirstResponder];
}

-(void)scrollViewTapDetector:(id) action
{
    [_activeTextField resignFirstResponder];
}

@end
