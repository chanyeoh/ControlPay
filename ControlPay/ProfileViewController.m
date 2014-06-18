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
#import "NotificationViewController.h"
#import "AFImageRequestOperation.h"

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "ConstantVariables.h"
#import "AddExpenditureViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
{
    NSArray * heading;
    NSMutableArray * pricing;
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
    pricing = [NSMutableArray arrayWithObjects:@"$0",@"$0",nil];
    labelItems = [NSArray arrayWithObjects:@"expensesItem.png",@"incomesItem.png",nil];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0.0, 0.0, 30, 30)];
    [[rightButton layer] setBorderWidth:1.0f];
    [[rightButton layer] setCornerRadius:7.0f];
    [[rightButton layer] setBorderColor:[UIColor colorWithRed:1.0 green:91.0/255.0 blue:84.0/255.0 alpha:1.0].CGColor];
    [rightButton setImage:[UIImage imageNamed:@"notificationButton.png"] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(8, 6, 8, 6)];
    [rightButton addTarget:self action:@selector(notificationButton:) forControlEvents:UIControlEventTouchUpInside];

    //rightButton.titleLabel.textColor = [UIColor lightGrayColor];
    
    
    // Set the image to its image property.
    //[rightButton setImage:collectionsRightImage forState:UIControlStateNormal];
    
    badge = [[UILabel alloc] initWithFrame:CGRectMake(rightButton.frame.size.width - 6.0, rightButton.frame.origin.y - 8.0, 15.0, 15.0)];
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
    [badge setHidden:YES];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forBarMetrics:UIBarMetricsDefault];
    
    //GaussianBlur Option Background;
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[backgroundDesignViewController blur:45.5f withImage:[UIImage imageNamed:@"wallpapers5.jpg"]]];
    
	//StackBlur Option Background;
    imagePreview.image=[[UIImage imageNamed:@"sliderBack.jpg"] stackBlur:20];
    
    //UIImageView *profPic = [UIImage imageNamed:@"lionProfile.jpg"];
    profilePic.layer.cornerRadius = 10.0f;
    profilePic.layer.masksToBounds = YES;
    profilePic.layer.borderWidth = 1.7f;
    profilePic.layer.borderColor = [UIColor colorWithRed:48.0/255.0 green:144.0/255.0 blue:199.0/255.0 alpha:0.7].CGColor;
    profilePic.image = [UIImage imageNamed:@"lionProfile.jpg"];
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageSelect:)];
    [profilePic addGestureRecognizer:imageTap];
    
    addExpenses.layer.borderColor = [UIColor colorWithRed:48.0/255.0 green:144.0/255.0 blue:199.0/255.0 alpha:0.7].CGColor;
    addExpenses.layer.borderWidth = 1.0f;
    addExpenses.layer.cornerRadius = 5.0f;
    addIncomes.layer.borderColor = [UIColor colorWithRed:48.0/255.0 green:144.0/255.0 blue:199.0/255.0 alpha:0.7].CGColor;
    addIncomes.layer.borderWidth = 1.0f;
    addIncomes.layer.cornerRadius = 5.0f;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"notiCount"]){
        [badge setHidden:NO];
        [badge setText:[userDefaults objectForKey:@"notiCount"]];
    }
    if([userDefaults objectForKey:@"income"]){
        [pricing setObject:[NSString stringWithFormat:@"$%@", [userDefaults objectForKey:@"income"]] atIndexedSubscript:1] ;
    }
    if([userDefaults objectForKey:@"expenditure"]){
        [pricing setObject:[NSString stringWithFormat:@"$%@", [userDefaults objectForKey:@"expenditure"]] atIndexedSubscript:0];
    }
    
}

-(void)getBasicData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AFHTTPClient *httpClientFollower = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClientFollower requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"%@%@/%@", BASE_URL, GET_BASIC,[userDefaults objectForKey:@"id"]]
                                                              parameters:nil];
    AFHTTPRequestOperation *followOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClientFollower registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [followOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSString *basicString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *myArr = [basicString componentsSeparatedByString:@";"];
        if([myArr objectAtIndex:0]){
            [badge setHidden:NO];
            [badge setText:[myArr objectAtIndex:0]];
            [userDefaults setObject:[myArr objectAtIndex:0] forKey:@"notiCount"];
        }
        if([myArr objectAtIndex:1]){
            [pricing setObject:[NSString stringWithFormat:@"$%@", [myArr objectAtIndex:1]] atIndexedSubscript:1];
            [userDefaults setObject:[myArr objectAtIndex:1] forKey:@"income"];
        }
        if([myArr objectAtIndex:2]){
            [pricing setObject:[NSString stringWithFormat:@"$%@", [myArr objectAtIndex:2]] atIndexedSubscript:0];
            [userDefaults setObject:[myArr objectAtIndex:2] forKey:@"expenditure"];
        }
        [userDefaults synchronize];
        [summaryTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"%@", error);
        if([userDefaults objectForKey:@"notiCount"]){
            [badge setHidden:NO];
            [badge setText:[userDefaults objectForKey:@"notiCount"]];
        }
        if([userDefaults objectForKey:@"income"]){
            [pricing setObject:[NSString stringWithFormat:@"$%@", [userDefaults objectForKey:@"income"]] atIndexedSubscript:1] ;
        }
        if([userDefaults objectForKey:@"expenditure"]){
            [pricing setObject:[NSString stringWithFormat:@"$%@", [userDefaults objectForKey:@"expenditure"]] atIndexedSubscript:0];
        }
        [summaryTableView reloadData];
    }];
    
    [followOperation start];
}

-(void)getUserData{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        AFHTTPClient *httpClientFollower = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        NSMutableURLRequest *request = [httpClientFollower requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"%@%@/%@", BASE_URL, GET_URL,[userDefaults objectForKey:@"id"]]
                                                              parameters:nil];
    
        AFHTTPRequestOperation *followOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [httpClientFollower registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [followOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Print the response body in text
            NSError *e = nil;
            NSDictionary *accountDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
            if([accountDictionary objectForKey:@"displayPicture"]!= [NSNull null]){
                [userDefaults setObject:[accountDictionary objectForKey:@"displayPicture"] forKey:@"profilePic"];
                //[self getImageUrl: [accountDictionary objectForKey:@"displayPicture"]];
                [userDefaults synchronize];
            }
            [self getBasicData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        }];
    
        [followOperation start];
    });
}

-(void)getImageUrl:(NSString *)imageurl{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:imageurl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        
        [AFImageRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"image/jpg"]];
        AFImageRequestOperation *requestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [profilePic setImage:image];
        
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"%@", error);
        } ];
    [requestOperation start];
        });
}

#pragma mark -
#pragma mark Image Picker
- (void)imageSelect:(UITapGestureRecognizer*)sender {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Code here to work with media
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *profileImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if([UIImageJPEGRepresentation(profileImage, 1) length] > 10 *1024*1024){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Image Size Too Large" message:@"Image Size Too Large" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
     NSData *imageData = UIImageJPEGRepresentation(profileImage, 1);
     NSURL *url = [NSURL URLWithString:BASE_URL];
     AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
     NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:UPDATE_PROFILE parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
     [formData appendPartWithFileData:imageData name:@"file" fileName:@"profilepicture.jpg" mimeType:@"image/jpg"];
     [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]] dataUsingEncoding:NSUTF8StringEncoding] name:@"userid"];
     }];
     
    
     
     AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
     [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
     
     // if you want progress updates as it's uploading, uncomment the following:
     [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     //NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }];
     
     [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *e = nil;
         NSDictionary *accountDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
         if([accountDictionary objectForKey:@"displayPicture"] != [NSNull null]){
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             [userDefaults setObject:[accountDictionary objectForKey:@"displayPicture"] forKey:@"profilePic"];
             //[self getImageUrl: [accountDictionary objectForKey:@"displayPicture"]];
             [userDefaults synchronize];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error);
     }];
     
     [operation start];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self getUserData];
}

-(void)viewDidDisappear:(BOOL)animated{
    _container.panMode = MFSideMenuPanModeNone;
}

#pragma mark -
#pragma mark IBActions Method
-(IBAction)notificationButton:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    // Notificaiton View Controller
    NotificationViewController * notificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    [self.navigationController pushViewController:notificationViewController animated:YES];
    
}

-(IBAction)addExpensesButton:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    // Notificaiton View Controller
    AddExpenditureViewController * AddExpenditureViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddExpenditureViewController"];
    [self.navigationController pushViewController:AddExpenditureViewController animated:YES];
    
}


#pragma mark -
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
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
    
    //cell.headingLabel.layer.cornerRadius = 5.0f;
    //cell.headingLabel.layer.masksToBounds = YES;

    cell.headingLabel.image = [UIImage imageNamed:[labelItems objectAtIndex:indexPath.row]];
    //cell.layer.cornerRadius = 500.0f;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
