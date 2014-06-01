//
//  Notifications.m
//  ControlPay
//
//  Created by Avik Bag on 5/23/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationCell.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
 return 0;
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
    //NSDictionary *theDictionary = [pendingFriends objectAtIndex:indexPath.row];
    //NSDictionary *friendDictionary = [theDictionary objectForKey:@"frienAccount"];
    //cell.username.text = [friendDictionary objectForKey:@"fullName"];
    [cell.username setTextColor:[UIColor cyanColor]];
    //cell.notificationType.text = [theDictionary objectForKey:@"status"];
    
    /*    // Custom Button on each cell
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
     */
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
