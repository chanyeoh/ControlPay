//
//  AddDebtsViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 5/11/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "AddDebtsViewController.h"
#import "SlideCell.h"
#import "SelectFriendViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "MBProgressHUD.h"
#import "ConstantVariables.h"
#import "backgroundDesignViewController.h"
#import "Friend.h"
#import "UIImage+StackBlur.h"

@interface AddDebtsViewController ()

@end

@implementation AddDebtsViewController

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
    _friendsArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[backgroundDesignViewController blur:1.5f withImage:[UIImage imageNamed:@"wallpapers5.jpg"]]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    imagePreview.image=[[UIImage imageNamed:@"wowWallpaper5.jpg"] stackBlur:75];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [friendTableView reloadData];
}

#pragma mark -
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_friendsArray count] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SlideCell";
    
    SlideCell *cell = (SlideCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)		    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SlideCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        // Swipe Gesture
        if(indexPath.row < [_friendsArray count]){
            UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
            [panRecognizer setMinimumNumberOfTouches:1];
            [panRecognizer setMaximumNumberOfTouches:1];
            [cell addGestureRecognizer:panRecognizer];
        }
    }
    if(indexPath.row >= [_friendsArray count]){
        [cell.friendLabel setHidden:YES];
        [cell.moneyLabel setHidden:YES];
        [cell.addButton setHidden:NO];
        [cell.addButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    NSDictionary *theDictionary = [_friendsArray objectAtIndex:indexPath.row];
    Friend *friend = [theDictionary objectForKey:@"friend"];
    
    cell.friendLabel.text = friend.fullName;
    cell.moneyLabel.text = [NSString stringWithFormat:@"$%@", [theDictionary objectForKey:@"money"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Button Touch
-(IBAction)confirmButton:(id)sender{
    MBProgressHUD*HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"Adding..";

     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    count = 0;
    int initialCount = _friendsArray.count;
    for (NSDictionary *friendArrDict in _friendsArray) {
        Friend *friend = [friendArrDict objectForKey:@"friend"];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[userDefaults objectForKey:@"id"], @"senderId", friend.id, @"friendId", [friendArrDict objectForKey:@"money"], @"debtAmount",  nil];
        
        NSURL *url = [NSURL URLWithString:BASE_URL];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        
        [httpClient setParameterEncoding:AFJSONParameterEncoding];
        [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [httpClient postPath:ADD_DEBTS parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            count ++;
            if(count >= initialCount){
                [HUD hide:YES afterDelay:0.5];
                [friendTableView reloadData];
            }

            NSError *e = nil;
            NSDictionary *searchFriendArray =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
            for (int i = 0; i < _friendsArray.count; i++) {
                NSDictionary *friendsDictionary = [_friendsArray objectAtIndex:i];
                if([[[friendsDictionary objectForKey:@"friendId"] stringValue] isEqualToString:[[searchFriendArray objectForKey:@"friendId"] stringValue]]){
                    [_friendsArray removeObjectAtIndex:i];
                    break;
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HUD hide:YES afterDelay:0.5];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed to Connect" message:@"Failed to Connect to Server, please check your internet connection" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            count ++;
            if(count >= initialCount){
                [HUD hide:YES afterDelay:0.5];
                [friendTableView reloadData];
            }
        }];
    }
}

-(IBAction)addFriend:(id)sender{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    SelectFriendViewController *controller = (SelectFriendViewController*)[mainStoryboard
                                                       instantiateViewControllerWithIdentifier: @"SelectFriendViewController"];
    controller.addDebts = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark Swipe Gesture
- (void)cellSwiped:(UIPanGestureRecognizer *)gesture {
    SlideCell *cell = (SlideCell *)gesture.view;
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        // Get the location of our touch, this time in the context of the superview.
        CGPoint location = [gesture locationInView:self.view];
        CGRect cellView = CGRectMake(0, 0, location.x, 60);
        cell.overLayView.frame = cellView;
        
    }else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [gesture locationInView:self.view];
        if(location.x < 200){
            NSIndexPath *indexPath = [friendTableView indexPathForCell:cell];
            [_friendsArray removeObjectAtIndex:indexPath.row];
            [friendTableView reloadData];
            return;
        }
        CGRect cellView = CGRectMake(0, 0, 320, 60);
        cell.overLayView.frame = cellView;
    }
}
@end
