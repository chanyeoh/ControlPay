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
#import "DebtsViewController.h"
#import "SettingsViewController.h"
#import "UIImage+StackBlur.h"

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
    sideBarArray = [[NSArray alloc] initWithObjects:@"Profile", @"Expenditures", @"Debts", @"Friends", @"Settings", @"Logout", nil];
    
    // The Layout and design end of the page
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[backgroundDesignViewController blur:1.5f withImage:[UIImage imageNamed:@"backgroundBlurDef.jpg"]]];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wowWallpaper4.jpg"]];
    imagePreview.image=[[UIImage imageNamed:@"wowWallpaper5.jpg"] stackBlur:175];
    
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
    DebtsViewController *debtViewController = [storyboard instantiateViewControllerWithIdentifier:@"DebtsViewController"];
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

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sideBarArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SideMenuCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
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

@end
