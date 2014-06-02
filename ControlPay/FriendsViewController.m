//
//  FriendsViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 4/12/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsCell.h"
#import "UIImage+ImageEffects.h"
#import "backgroundDesignViewController.h"

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "MBProgressHUD.h"
#import "ConstantVariables.h"
#import "Friend.h"
#import "UIImage+StackBlur.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

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
    
    self.view.backgroundColor = [UIColor blackColor];
    [self setNeedsStatusBarAppearanceUpdate];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"9A9A9A-0.8.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    // The Layout and design end of the page
    
    //StackBlur Option Background;
    imagePreview.image=[[UIImage imageNamed:@"sliderBack.jpg"] stackBlur:20];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

-(void)viewDidAppear:(BOOL)animated{
    [self getFriendsData];
    _container.panMode = MFSideMenuPanModeDefault;
}

-(void)viewDidDisappear:(BOOL)animated{
    _container.panMode = MFSideMenuPanModeNone;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toggleSwitch:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_container setMenuState:MFSideMenuStateLeftMenuOpen];
    });
}

-(IBAction)segmentValueChanged:(id)sender{
    UISegmentedControl *s = (UISegmentedControl *)sender;
    
    if (s.selectedSegmentIndex == 0){
        friendsArray = [[NSMutableArray alloc]init];
        NSData *friendData = [[NSUserDefaults standardUserDefaults] objectForKey:@"friendArray"];
        NSMutableArray *updatedFriendArray = [NSKeyedUnarchiver unarchiveObjectWithData:friendData];
        
        [self showData:updatedFriendArray];
    }else{
        friendsArray = [[NSMutableArray alloc]init];
        NSData *friendData = [[NSUserDefaults standardUserDefaults] objectForKey:@"friendArray"];
        NSMutableArray *updatedFriendArray = [NSKeyedUnarchiver unarchiveObjectWithData:friendData];

        for (Friend *f in updatedFriendArray) {
            if([f.status isEqualToString:@"PENDING"]){
                [friendsArray addObject:f];
            }
        }
        [friendTableView reloadData];
    }
}
#pragma mark -
#pragma mark Friend Actions
-(void)acceptFriendAlgo:(id)sender{
    NSDictionary *theDictionary = [friendsArray objectAtIndex:[sender tag]];
    
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
#pragma mark Networking
-(void)getFriendsData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AFHTTPClient *httpClientFollower = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClientFollower requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"%@%@/%@", BASE_URL, GET_FRIENDS_URL,[userDefaults objectForKey:@"id"]]
                                                              parameters:nil];
    
    AFHTTPRequestOperation *followOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClientFollower registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [followOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSError *e = nil;
        NSArray *wholeFriendArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        
        // Store Data
        NSMutableArray *updatedFriendArray = [[NSMutableArray alloc]init];
        for (NSDictionary *friendDict in wholeFriendArray) {
            Friend *friend = [[Friend alloc]init];
            [friend updateContext:friendDict];
            [updatedFriendArray addObject:friend];
        }
        
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:updatedFriendArray];
        [userDefaults setObject:data forKey:@"friendArray"];
        [userDefaults synchronize];
        
        [self showData:updatedFriendArray];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //NSLog(@"%@", error);
            NSData *friendData = [[NSUserDefaults standardUserDefaults] objectForKey:@"friendArray"];
            NSMutableArray *updatedFriendArray = [NSKeyedUnarchiver unarchiveObjectWithData:friendData];
            [self showData:updatedFriendArray];
    }];
    
    [followOperation start];
}

-(void)showData:(NSMutableArray *)updatedFriendArray{
    friendsArray = [[NSMutableArray alloc]init];
    int pendingCounter = 0;
    for (Friend *f in updatedFriendArray) {
        if([f.status isEqualToString:@"ACCEPTED"]){
            [friendsArray addObject:f];
        }else if([f.status isEqualToString:@"PENDING"]){
            pendingCounter ++;
        }
    }
    
    [friendTableView reloadData];

}

#pragma mark -
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friendsArray count];
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
    Friend *friend =[friendsArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = friend.fullName;
    [cell.nameLabel setTextColor:[UIColor cyanColor]];
    cell.subHeading.text = friend.status;
    
    // Custom Button on each cell
    if(segmentControl.selectedSegmentIndex == 1){
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
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
