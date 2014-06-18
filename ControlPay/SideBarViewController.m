//
//  SideBarViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 4/10/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "SideBarViewController.h"
#import "ExpenditureViewController.h"
//#import "backgroundDesignViewController.h"

#import "ProfileViewController.h"
#import "FriendsViewController.h"
#import "AddDebtsViewController.h"
#import "SettingsViewController.h"
#import "UIImage+StackBlur.h"
#import <QuartzCore/QuartzCore.h>

#import "ProfileHeaderCell.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFImageRequestOperation.h"
#import "ConstantVariables.h"


@interface SideBarViewController ()

@end

@implementation SideBarViewController

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
    sideBarArray = [[NSArray alloc] initWithObjects:@"Profile", @"Expenditures", @"Debts", @"Friends", nil];
    
    // The Layout and design end of the page
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[backgroundDesignViewController blur:1.5f withImage:[UIImage imageNamed:@"backgroundBlurDef.jpg"]]];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wowWallpaper4.jpg"]];
    
    // Button design
    logOut.layer.borderWidth = 1.0f;
    logOut.layer.cornerRadius = 5.0f;
    logOut.layer.borderColor = [UIColor whiteColor].CGColor;
    logOut.layer.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:144.0/255.0 blue:199.0/255.0 alpha:0.28].CGColor;
    
    resetPass.layer.borderWidth = 1.0f;
    resetPass.layer.cornerRadius = 5.0f;
    resetPass.layer.borderColor = [UIColor whiteColor].CGColor;
    resetPass.layer.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:144.0/255.0 blue:199.0/255.0 alpha:0.28].CGColor;
    
    //StackBlur Option Background;
    imagePreview.image=[[UIImage imageNamed:@"singaporeSkyline.jpg"] stackBlur:20];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    viewControllerArray = [[NSMutableArray alloc]init];
    
    // Profile View Controller
    ProfileViewController * profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    profileViewController.container = _sidemenuContainer;
    UINavigationController *profileNavController = [[UINavigationController alloc]initWithRootViewController:profileViewController];
    [viewControllerArray addObject:profileNavController];
    
    // Expenditure View Controller
    ExpenditureViewController * expenditureViewController = [storyboard instantiateViewControllerWithIdentifier:@"ExpenditureViewController"];
    expenditureViewController.container = _sidemenuContainer;
    UINavigationController *expenditureNavController = [[UINavigationController alloc]initWithRootViewController:expenditureViewController];
    [viewControllerArray addObject:expenditureNavController];
    
    // Debts View Controller
    AddDebtsViewController *debtViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddDebtsViewController"];
    debtViewController.container = _sidemenuContainer;
    UINavigationController *debtNavController = [[UINavigationController alloc]initWithRootViewController:debtViewController];
    [viewControllerArray addObject:debtNavController];
    
    // Friends View Controller
    FriendsViewController *friendViewController = [storyboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];
    friendViewController.container = _sidemenuContainer;
    UINavigationController *friendNavController = [[UINavigationController alloc]initWithRootViewController:friendViewController];
    [viewControllerArray addObject:friendNavController];
    
    // Settings View Controller
    SettingsViewController *settingViewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    settingViewController.container = _sidemenuContainer;
    UINavigationController *settingNavController = [[UINavigationController alloc]initWithRootViewController:settingViewController];
    [viewControllerArray addObject:settingNavController];
    
}

-(UIImageView*)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
    
    return roundedView;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    [sideBarTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBasicData:(UILabel *)label withUIImageView:(UIImageView *)imageView{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AFHTTPClient *httpClientFollower = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClientFollower requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"%@%@/%@", BASE_URL, GET_URL,[userDefaults objectForKey:@"id"]]
                                                              parameters:nil];
    AFHTTPRequestOperation *followOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClientFollower registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [followOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *e = nil;
        NSDictionary *theDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        //[self getImageUrl:[theDictionary objectForKey:@"displayPicture"] withUIImageView:imageView];
        [label setText:[theDictionary objectForKey:@"fullName"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { }];
    
    [followOperation start];
}

-(void)getImageUrl:(NSString *)imageurl withUIImageView:(UIImageView *)imageView{
    if([imageurl isEqual:[NSNull null]])
       return;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:imageurl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        
        [AFImageRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"image/jpg"]];
        AFImageRequestOperation *requestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [imageView setImage:image];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"%@", error);
        } ];
        [requestOperation start];
    });
}

#pragma mark -
#pragma mark TableView for elements
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sideBarArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"";
    if (indexPath.row == 0)
    {
        simpleTableIdentifier = @"ProfileHeaderCell";
        
        ProfileHeaderCell *cell = (ProfileHeaderCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)		    {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }

        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 58, cell.contentView.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        
        [cell.contentView addSubview:lineView];
        cell.backgroundColor = [UIColor clearColor];
        [self setRoundedView:cell.profilePic toDiameter:40.0];
        cell.profilePic.layer.masksToBounds = YES;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.profilePic.layer.borderWidth = 1.0f;
        cell.profilePic.image = [UIImage imageNamed:@"lionProfile.jpg"];
        [self setBasicData:cell.profileText withUIImageView:cell.profilePic];
        
        return cell;
        
    }

    simpleTableIdentifier = @"SideMenuCell";
        
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UIFont *myFont = [ UIFont fontWithName: @"Avenir" size: 17.0 ];
    cell.textLabel.font  = myFont;
    cell.textLabel.text = [sideBarArray objectAtIndex:indexPath.row];
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
    
    if(indexPath.row == 5){
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    _sidemenuContainer.centerViewController =[viewControllerArray objectAtIndex:indexPath.row];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_sidemenuContainer setMenuState:MFSideMenuStateClosed];
    });
}

-(IBAction)resetPassButton:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    // Settings View Controller
    SettingsViewController *settingViewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    settingViewController.container = _sidemenuContainer;
    UINavigationController *settingNavController = [[UINavigationController alloc]initWithRootViewController:settingViewController];
    _sidemenuContainer.centerViewController =settingNavController;
}

-(IBAction)logOutButton:(id)sender{
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    //_sidemenuContainer.centerViewController =[viewControllerArray objectAtIndex:indexPath.row];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_sidemenuContainer setMenuState:MFSideMenuStateClosed];
    });
    
    
}



@end
