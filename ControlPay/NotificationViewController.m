//
//  Notifications.m
//  ControlPay
//
//  Created by Avik Bag on 5/23/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationCell.h"
#import "ConstantVariables.h"

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "UIImage+StackBlur.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

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
    [self getData];
    //StackBlur Option Background;
    imagePreview.image=[[UIImage imageNamed:@"sliderBack.jpg"] stackBlur:20];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AFHTTPClient *httpClientFollower = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClientFollower requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"%@%@/%@", BASE_URL, NOTIFICATION_URL,[userDefaults objectForKey:@"id"]]
                                                              parameters:nil];
    
    AFHTTPRequestOperation *followOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClientFollower registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [followOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSError *e = nil;
        notificationArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        NSLog(@"%@", notificationArray);
        [notificationTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [followOperation start];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 return [notificationArray count];
}
 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"NotificationCell";
    
    NotificationCell *cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)		    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Notification" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *theDictionary = [notificationArray objectAtIndex:indexPath.row];
    NSDictionary *friendDictionary = [theDictionary objectForKey:@"userAccount"];
    NSLog(@"%@", friendDictionary);

    [cell.notificationText setText:[NSString stringWithFormat:@"%@%@",  [friendDictionary objectForKey:@"fullName"], [theDictionary objectForKey:@"notification"]]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
