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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[backgroundDesignViewController blur:1.5f withImage:[UIImage imageNamed:@"wallpapers5.jpg"]]];
    
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
    return 65;
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
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([amountMoney.text isEqualToString:@""]){
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Enter Friend Owe Amount" message:@"Please Enter Owe Amount" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *friendDict = [[NSMutableDictionary alloc]init];
    Friend *friend = [friendArray objectAtIndex:indexPath.row];
    [friendDict setObject:friend forKey:@"friend"];
    [friendDict setObject:amountMoney.text forKey:@"money"];
    [_addDebts.friendsArray addObject:friendDict];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
