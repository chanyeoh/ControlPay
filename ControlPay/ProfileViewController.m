//
//  ProfileViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 5/17/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCell.h"
//#import "backgroundDesignViewController.h"
#import "UIImage+StackBlur.h"
#import <QuartzCore/QuartzCore.h>


@interface ProfileViewController ()

@end

@implementation ProfileViewController
{
    NSArray * heading;
    NSArray * pricing;
    NSArray * labelItems;
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
    
    heading = [NSArray arrayWithObjects:@"Expenditure",@"Incomes",nil];
    pricing = [NSArray arrayWithObjects:@"$555",@"$267",nil];
    labelItems = [NSArray arrayWithObjects:@"expensesItem.png",@"incomesItem.png",nil];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0.0, 0.0, 30, 30)];
    [[rightButton layer] setBorderWidth:1.0f];
    [[rightButton layer] setCornerRadius:7.0f];
    [[rightButton layer] setBorderColor:[UIColor colorWithRed:1.0 green:91.0/255.0 blue:84.0/255.0 alpha:1.0].CGColor];
    [rightButton setImage:[UIImage imageNamed:@"notificationButton.png"] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(8, 6, 8, 6)];

    //rightButton.titleLabel.textColor = [UIColor lightGrayColor];
    
    
    // Set the image to its image property.
    //[rightButton setImage:collectionsRightImage forState:UIControlStateNormal];
    
    UILabel *badge = [[UILabel alloc] initWithFrame:CGRectMake(rightButton.frame.size.width - 6.0, rightButton.frame.origin.y - 8.0, 15.0, 15.0)];
    // Set the background color.
    [badge setBackgroundColor:[UIColor colorWithRed:1.0 green:91.0/255.0 blue:84.0/255.0 alpha:1.0]];
    // Set the corner radius value to make the label appear rounded.
    [[badge layer] setBorderWidth:1.0f];
    badge.layer.masksToBounds = YES;
    [[badge layer] setCornerRadius:8.0];
    [[badge layer] setBorderColor:[UIColor colorWithRed:1.0 green:91.0/255.0 blue:84.0/255.0 alpha:1.0].CGColor];
    
    // Set its value, alignment, color and font.
    [badge setText:@"5"];
    [badge setTextAlignment:NSTextAlignmentCenter];
    [badge setTextColor:[UIColor whiteColor]];
    [badge setFont:[UIFont fontWithName:@"Avenir" size:12.0]];
    // Add the image as a subview to the custom button.
    [rightButton addSubview:badge];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forBarMetrics:UIBarMetricsDefault];
    
    //GaussianBlur Option Background;
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[backgroundDesignViewController blur:45.5f withImage:[UIImage imageNamed:@"wallpapers5.jpg"]]];
    
	//StackBlur Option Background;
    imagePreview.image=[[UIImage imageNamed:@"wowWallpaper5.jpg"] stackBlur:75];
    
    //UIImageView *profPic = [UIImage imageNamed:@"lionProfile.jpg"];
    profilePic.layer.cornerRadius = 10.0f;
    profilePic.layer.masksToBounds = YES;
    profilePic.layer.borderWidth = 1.7f;
    profilePic.layer.borderColor = [UIColor colorWithRed:48.0/255.0 green:144.0/255.0 blue:199.0/255.0 alpha:0.7].CGColor;
    profilePic.image = [UIImage imageNamed:@"lionProfile.jpg"];
    
    
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

-(void)viewDidAppear:(BOOL)animated{
    _container.panMode = MFSideMenuPanModeDefault;
}

-(void)viewDidDisappear:(BOOL)animated{
    _container.panMode = MFSideMenuPanModeNone;
}

#pragma mark -
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ProfileCell";
    
    ProfileCell *cell = (ProfileCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)		    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    
    [cell.contentView addSubview:lineView];

    cell.titleText.text = [heading objectAtIndex:indexPath.row];
    cell.priceText.text = [pricing objectAtIndex:indexPath.row];
    
    cell.headingLabel.layer.cornerRadius = 5.0f;
    cell.headingLabel.layer.masksToBounds = YES;

    cell.headingLabel.image = [UIImage imageNamed:[labelItems objectAtIndex:indexPath.row]];
    //cell.layer.cornerRadius = 500.0f;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
