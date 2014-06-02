//
//  AddFriendViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 4/27/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "AddFriendViewController.h"
#import "FriendsCell.h"
#import "ConstantVariables.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"
#import "AFJSONRequestOperation.h"
#import "backgroundDesignViewController.h"
#import "UIImage+StackBlur.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

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
    searchFriendArray = [[NSMutableArray alloc]init];

    //self.view.backgroundColor = [UIColor colorWithPatternImage:[backgroundDesignViewController blur:1.5f withImage:[UIImage imageNamed:@"wallpapers5.jpg"]]];
    //StackBlur Option Background;
    imagePreview.image=[[UIImage imageNamed:@"sliderBack.jpg"] stackBlur:20];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark -
#pragma mark Search Bar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchBarText = searchBar.text;
    if ([self isPhone:searchBarText]) {
        [self phoneSearch:searchBarText];
    }else{
        [self usernameSearch:searchBarText];
    }
    [searchBar resignFirstResponder];
}

-(BOOL)isPhone:(NSString *)phoneNumber{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [phoneNumber rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}

-(void)phoneSearch:(NSString *)text{
    MBProgressHUD*HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Searching...";
    AFHTTPClient *httpClientFollower = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClientFollower requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"%@%@/%@", BASE_URL, SEARCH_PHONE_URL,text]
                                                              parameters:nil];
    
    AFHTTPRequestOperation *followOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClientFollower registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [followOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES afterDelay:0.5];
        // Print the response body in text
        NSError *e = nil;
        searchFriendArray =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        [searchFriendTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"%@", error);
        [HUD hide:YES afterDelay:0.5];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed to Connect" message:@"Failed to Connect to Server, please check your internet connection" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }];
    
    [followOperation start];
}

-(void)usernameSearch:(NSString *)text{
    MBProgressHUD*HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Searching...";
    AFHTTPClient *httpClientFollower = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClientFollower requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"%@%@/%@", BASE_URL, SEARCH_USER_URL,text]
                                                              parameters:nil];
    
    AFHTTPRequestOperation *followOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClientFollower registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [followOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES afterDelay:0.5];
        // Print the response body in text
        NSError *e = nil;
        searchFriendArray =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        [searchFriendTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"%@", error);
        [HUD hide:YES afterDelay:0.5];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed to Connect" message:@"Failed to Connect to Server, please check your internet connection" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }];
    
    [followOperation start];
}

-(void)addFriend:(NSDictionary *)friendDictionary{
    MBProgressHUD*HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Adding..";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[userDefaults objectForKey:@"username"], @"username", [userDefaults objectForKey:@"id"], @"id", nil];
    NSURL *url = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient postPath:[NSString stringWithFormat:@"%@/%@/%@",ADD_FRIENDS_URL, [friendDictionary objectForKey:@"id"], [friendDictionary objectForKey:@"username"]] parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES afterDelay:0.5];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES afterDelay:0.5];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed to Connect" message:@"Failed to Connect to Server, please check your internet connection" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }];
}

#pragma mark -
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchFriendArray count];
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
    NSDictionary *dictionary = [searchFriendArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [dictionary objectForKey:@"fullName"];
    cell.subHeading.text = [dictionary objectForKey:@"username"];
    
    // Custom Button on each cell
    UIButton * addFriends = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addFriends.frame = CGRectMake(254.0f, 17.0f, 40.0f , 25.0f);
    addFriends.tag = indexPath.row;
    addFriends.backgroundColor = [UIColor clearColor];
    [addFriends setTitle:@"+" forState:UIControlStateNormal];
    [addFriends setTintColor:[UIColor whiteColor]];
    [addFriends addTarget:self action:@selector(addFriendAlgo:) forControlEvents:UIControlEventTouchUpInside];
    [[addFriends layer] setBorderWidth:1.0f];
    [[addFriends layer] setBorderColor:[UIColor cyanColor].CGColor];
    addFriends.layer.cornerRadius = 8.0f;
    [cell addSubview:addFriends];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)addFriendAlgo:(id)sender{
    NSDictionary *dictionary = [searchFriendArray objectAtIndex:[sender tag]];
    [self addFriend:dictionary];
}
@end
