//
//  AcceptFriendViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 4/29/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "AcceptFriendViewController.h"
#import "FriendsCell.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "ConstantVariables.h"
#import "MBProgressHUD.h"

@interface AcceptFriendViewController ()

@end

@implementation AcceptFriendViewController

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
    pendingFriends = [[NSMutableArray alloc]init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *jsonString = [userDefaults objectForKey:@"friendArray"];
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSArray *friendDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    for (NSDictionary *dict in friendDictionary) {
        if([[dict objectForKey:@"status"] isEqualToString:@"PENDING"]){
            [pendingFriends addObject:dict];
        }
    }
    [pendingTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Friend Actions
-(void)acceptFriendAlgo:(id)sender{
    NSDictionary *theDictionary = [pendingFriends objectAtIndex:[sender tag]];
    
    MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Accepting...";

    NSURL *url = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient postPath:[NSString stringWithFormat:@"%@/%@", ACCEPT_FRIENDS_URL, [theDictionary objectForKey:@"id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES afterDelay:0.5];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Server Response" message:@"Friend Accepted" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES afterDelay:0.5];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed to Connect" message:@"Failed to Connect to Server, please check your internet connection" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }];
}

#pragma mark -
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [pendingFriends count];
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
    NSDictionary *theDictionary = [pendingFriends objectAtIndex:indexPath.row];
    NSDictionary *friendDictionary = [theDictionary objectForKey:@"frienAccount"];
    cell.nameLabel.text = [friendDictionary objectForKey:@"fullName"];
    [cell.nameLabel setTextColor:[UIColor cyanColor]];
    cell.subHeading.text = [theDictionary objectForKey:@"status"];
    
    // Custom Button on each cell
    UIButton * addFriends = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addFriends.frame = CGRectMake(254.0f, 23.0f, 40.0f , 25.0f);
    addFriends.tag = indexPath.row;
    addFriends.backgroundColor = [UIColor clearColor];
    [addFriends setTitle:@"✓" forState:UIControlStateNormal];
    [addFriends setTintColor:[UIColor whiteColor]];
    [addFriends addTarget:self action:@selector(acceptFriendAlgo:) forControlEvents:UIControlEventTouchUpInside];
    [[addFriends layer] setBorderWidth:1.0f];
    [[addFriends layer] setBorderColor:[UIColor cyanColor].CGColor];
    addFriends.layer.cornerRadius = 8.0f;
    [cell addSubview:addFriends];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
