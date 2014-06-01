//
//  ResetPasswordViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 5/23/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ConstantVariables.h"
#import "MBProgressHUD.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"


@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

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
    UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Change" style:UIBarButtonItemStylePlain target:self action:@selector(confirmPassword:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark Password Confirmation
-(IBAction)confirmPassword:(id)sender{
    NSString * currPasswordString = currPassword.text;
    NSString * newPasswordString = newPassword.text;
    NSString * repeatPasswordString = confirmNewPassword.text;
    
    if([currPasswordString isEqualToString:@""] || [newPasswordString isEqualToString:@""] || [repeatPasswordString isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Please Fill in all blanks" message:@"Please Fill in All blanks" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if(![newPasswordString isEqualToString:repeatPasswordString]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Make sure password match" message:@"Make sure password match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    
    MBProgressHUD*HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Adding..";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[userDefaults objectForKey:@"id"], @"id", [userDefaults objectForKey:@"username"], @"username", currPasswordString, @"password",  nil];
    
    NSURL *url = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient postPath:[NSString stringWithFormat:@"%@/%@", CHANGE_PASSWORD, repeatPasswordString] parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES afterDelay:0.5];
        NSError *e = nil;
        NSDictionary *serverResult =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Server Response" message:[serverResult objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES afterDelay:0.5];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed to Connect" message:@"Failed to Connect to Server, please check your internet connection" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }];
    
}

@end
