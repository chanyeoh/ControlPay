//
//  LoansViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 4/10/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "IncomesViewController.h"

#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"

#import "AFHTTPClient.h"
#import "Expenditure.h"
#import "AFJSONRequestOperation.h"
#import "ConstantVariables.h"
#import "UIImage+StackBlur.h"

@interface IncomesViewController ()

@end

@implementation IncomesViewController

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
    //StackBlur Option Background;
    imagePreview.image=[[UIImage imageNamed:@"sliderBack.jpg"] stackBlur:20];
    
    addIncomes.layer.cornerRadius = 5.0f;
    addIncomes.layer.borderColor = [UIColor whiteColor].CGColor;
    addIncomes.layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)addLoan:(id)sender{
    [amountTextfield resignFirstResponder];
    if([amountTextfield.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Please Fill in Everything" message:@"Please fill in Everything" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
        
        return;
    }
    MBProgressHUD*HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Adding..";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    Expenditure *expenditure = [[Expenditure alloc]init];
    expenditure.accountid = [userDefaults objectForKey:@"id"];
    expenditure.amount =[amountTextfield.text substringFromIndex:1];
    
    NSDictionary *dictionary = [expenditure toDictionary];
    
    NSURL *url = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient postPath:[NSString stringWithFormat:@"%@",ADD_INCOME] parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSError *e = nil;
        //NSDictionary *expenditureResult =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        
        [HUD hide:YES afterDelay:0.5];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES afterDelay:0.5];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed to Connect" message:@"Failed to Connect to Server, please check your internet connection" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Touches Began
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([textField.text rangeOfString:@"$"].location == NSNotFound){
        textField.text = [NSString stringWithFormat:@"$%@", textField.text];
    }
    return YES;
}
-(IBAction)cancelEditingForView:(id)sender {
    [[self view] endEditing:YES];
}

@end
