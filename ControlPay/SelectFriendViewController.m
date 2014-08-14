//
//  SelectFriendViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 5/11/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "SelectFriendViewController.h"
#import "FriendsCell.h"
#import "backgroundDesignViewController.h"
#import "Friend.h"
#import "UIImage+StackBlur.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "MBProgressHUD.h"
#import "ConstantVariables.h"

@interface SelectFriendViewController ()

@end

@implementation SelectFriendViewController

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
    NSData *friendData = [[NSUserDefaults standardUserDefaults] objectForKey:@"friendArray"];
    friendArray = [NSKeyedUnarchiver unarchiveObjectWithData:friendData];
    
    //StackBlur Option Background;
    imagePreview.image=[[UIImage imageNamed:@"sliderBack.jpg"] stackBlur:80];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friendArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"FriendsCell";
    
    FriendsCell *cell = (FriendsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)		    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    Friend *friend = [friendArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = friend.fullName;
    [cell.nameLabel setTextColor:[UIColor cyanColor]];
    cell.subHeading.text = friend.status;
    
    cell.textColor = [UIColor whiteColor];
    cell.textLabel.shadowColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 58, cell.contentView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    
    [cell.contentView addSubview:lineView];

    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([amountMoney.text isEqualToString:@""]){
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Enter Friend Owe Amount" message:@"Please Enter Owe Amount" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    MBProgressHUD*HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Adding..";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    Friend *friend = [friendArray objectAtIndex:indexPath.row];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[userDefaults objectForKey:@"id"], @"senderId", friend.id, @"friendId", amountMoney.text, @"debtAmount",  nil];
        
    NSURL *url = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient postPath:ADD_DEBTS parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSError *e = nil;
        //NSDictionary *searchFriendArray =[NSJSONSerialization JSONObjectWithData:responseObject options NSJSONReadingMutableContainers error:&e];
        [HUD hide:YES afterDelay:0.5];
        NSMutableDictionary *friendDict = [[NSMutableDictionary alloc]init];
        Friend *friend = [friendArray objectAtIndex:indexPath.row];
        [friendDict setObject:friend forKey:@"friend"];
        [friendDict setObject:amountMoney.text forKey:@"money"];
        [_addDebts.friendsArray addObject:friendDict];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES afterDelay:0.5];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed to Connect" message:@"Failed to Connect to Server, please check your internet connection" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }];
    
}

@end
