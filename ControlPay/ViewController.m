//
//  ViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 4/10/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "SideBarViewController.h"
#import "ProfileViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "ConstantVariables.h"
//#import "backgroundDesignViewController.h"
#import "UIImage+StackBlur.h"

#import "MBProgressHUD.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [theScrollView setContentSize:self.view.frame.size];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapDetector:)];
    singleTap.cancelsTouchesInView=NO;
    [singleTap setNumberOfTapsRequired:1];
    
    [theScrollView addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs objectForKey:@"username"]){
        [self pushToMainStory];
    }
    
// The Layout and design end of the page
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[backgroundDesignViewController blur:20.0f withImage:[UIImage imageNamed:@"wowWallpaper2.jpg"]]];
    
    imagePreview.image=[[UIImage imageNamed:@"singaporeSkyline.jpg"] stackBlur:5];
    
    usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forBarMetrics:UIBarMetricsDefault];
    
    //[self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
        
}

/*-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}*/

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginClick:(id)sender{
    MBProgressHUD*HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Logging in...";
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:usernameTextField.text, @"username", passwordTextField.text, @"password", nil];
    NSURL *url = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient postPath:LOGIN_URL parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        [HUD hide:YES afterDelay:0.5];
        if([[dictionary objectForKey:@"message"] isEqualToString:@"Login Successful"]){
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:[dictionary objectForKey:@"id"] forKey:@"id"];
            [prefs setObject:[dictionary objectForKey:@"username"] forKey:@"username"];
            [prefs setObject:[dictionary objectForKey:@"password"] forKey:@"password"];
            [prefs synchronize];
            
            [self pushToMainStory];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Server Response" message:[dictionary objectForKey:@"message"] delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES afterDelay:0.5];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed to Connect" message:@"Failed to Connect to Server, please check your internet connection" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }];
}



#pragma mark - 
#pragma mark Push to Main Story Board
// Push this to the sidebar view
-(void)pushToMainStory{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SideBarViewController *sideController = [storyboard instantiateViewControllerWithIdentifier:@"SideBarViewController"];
    UINavigationController *sideNavController = [[UINavigationController alloc]initWithRootViewController:sideController];
    
    ProfileViewController *profileController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    UINavigationController *profileNavController = [[UINavigationController alloc]initWithRootViewController:profileController];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:profileNavController
                                                    leftMenuViewController:sideNavController
                                                    rightMenuViewController:nil];
    sideController.sidemenuContainer = container;
    profileController.container = container;
    
    
    //container.panMode = MFSideMenuPanModeNone;
    //sideController.sideMenuContainer = container;
    //profileController.sideMenuContainer = container;
    [self presentViewController:container animated:YES completion:nil];
}

#pragma mark -
#pragma mark UIScrollView Hide
- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Step 1: Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    theScrollView.contentInset = contentInsets;
    theScrollView.scrollIndicatorInsets = contentInsets;
    
    
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(aRect, _activeTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, _activeTextField.frame.origin.y - (keyboardSize.height));
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
