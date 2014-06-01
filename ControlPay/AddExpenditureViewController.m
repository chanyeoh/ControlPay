//
//  AddExpenditureViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 5/10/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "AddExpenditureViewController.h"
#import "ProfileViewController.h"

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "ConstantVariables.h"
#import "MBProgressHUD.h"
#import "backgroundDesignViewController.h"
#import "Expenditure.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+StackBlur.h"

@interface AddExpenditureViewController ()

@end

@implementation AddExpenditureViewController
{
    NSArray *imageIcons;
}

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
    myCategories = [[NSArray alloc] initWithObjects:@"Transportation", @"Food",@"Books", @"Entertainment", @"Personal",@"Groceries", nil];
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCell"];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[backgroundDesignViewController blur:10.5f withImage:[UIImage imageNamed:@"wallpapers5.jpg"]]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forBarMetrics:UIBarMetricsDefault];
    _amountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"$ Enter Amount" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    [_amountTextField resignFirstResponder];
    
    imagePreview.image=[[UIImage imageNamed:@"sliderBack.jpg"] stackBlur:75];
    
    imageIcons = [NSArray arrayWithObjects:@"transportationIcon.png", @"foodIcon.png", @"educationIcon.png", @"partyIcon.png" ,@"personalIcon.png",@"groceriesIcon.png",nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)addButton:(id)sender{
    [_amountTextField resignFirstResponder];
    if(!selectedIndexPath || [_amountTextField.text isEqualToString:@""])
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
    expenditure.category =[myCategories objectAtIndex:selectedIndexPath.row];
    expenditure.amount =[_amountTextField.text substringFromIndex:1];
    
    NSDictionary *dictionary = [expenditure toDictionary];
    
    NSURL *url = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient postPath:[NSString stringWithFormat:@"%@",ADD_EXPENDITURE] parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

#pragma mark -
#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return myCategories.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CategoryCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:10];
    UIImageView *cellIMage = (UIImage *)[cell viewWithTag:9];
    textLabel.text = [myCategories objectAtIndex:indexPath.row];
    
    cellIMage.image = [UIImage imageNamed:[imageIcons objectAtIndex:indexPath.row]];
    
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    
    return cell;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:144.0/255.0 blue:199.0/255.0 alpha:0.7];
    /*if(selectedIndexPath){
     cell = [collectionView cellForItemAtIndexPath:selectedIndexPath];
     cell.backgroundColor = [UIColor redColor];
     }*/
    selectedIndexPath = indexPath;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    selectedIndexPath = indexPath;
}

@end
