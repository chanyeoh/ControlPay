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

#import "Debt.h"

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

    //StackBlur Option Background;
    imagePreview.image=[[UIImage imageNamed:@"sliderBack.jpg"] stackBlur:20];
    
    initialPosition = -1;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self getDebtConnection];
    [self getOweConnection];
    _container.panMode = MFSideMenuPanModeDefault;
    [friendTableView reloadData];
}



#pragma mark -
#pragma mark Connection Data
-(void)getDebtConnection{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AFHTTPClient *httpClientFollower = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClientFollower requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"%@%@/%@", BASE_URL, GET_DEBTS,[userDefaults objectForKey:@"id"]]
                                                              parameters:nil];
    
    AFHTTPRequestOperation *followOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClientFollower registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [followOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSError *e = nil;
        NSArray *debtList = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        
        debtArray = [[NSMutableArray alloc] init];
        NSMutableArray *myDebtsArray = [self combineExtraData: [debtList mutableCopy]];
        for (NSDictionary *debtDict in myDebtsArray) {
            Debt *debt = [[Debt alloc]init];
            [debt updateContext:debtDict];
            [debtArray addObject:debt];
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:debtArray];
        [userDefaults setObject:data forKey:@"debtsArray"];
        [userDefaults synchronize];
        [friendTableView reloadData];
        
        NSLog(@"Reload Once");
        //[NSThread sleepForTimeInterval:3];
        //[self getDebtConnection];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"%@", error);
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"debtsArray"];
        debtArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [friendTableView reloadData];
        
        //[NSThread sleepForTimeInterval:3];
        //[self getDebtConnection];
    }];
    
    [followOperation start];
    });
}

-(void)getOweConnection{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AFHTTPClient *httpClientFollower = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClientFollower requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"%@%@/%@", BASE_URL, OWE_DEBTS,[userDefaults objectForKey:@"id"]]
                                                              parameters:nil];
    
    followOperationOwe = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClientFollower registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [followOperationOwe setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSError *e = nil;
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *debtList = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        [userDefaults setObject:jsonString forKey:@"oweArray"];
        
        oweArray = [[NSMutableArray alloc] init];
        NSMutableArray *myDebtsArray = [self combineExtraData: [debtList mutableCopy]];
        for (NSDictionary *debtDict in myDebtsArray) {
            Debt *debt = [[Debt alloc]init];
            [debt updateContext:debtDict];
            [oweArray addObject:debt];
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:oweArray];
        [userDefaults setObject:data forKey:@"oweArray"];
        [userDefaults synchronize];
        
        [friendTableView reloadData];

        //[NSThread sleepForTimeInterval:3];
        //[self getOweConnection];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"%@", error);
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"oweArray"];
        oweArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [friendTableView reloadData];
        
        //[NSThread sleepForTimeInterval:3];
        //[self getOweConnection];
    }];
    
    [followOperationOwe start];
    });
}

-(NSMutableArray *)combineExtraData:(NSMutableArray *)debtList{
    for (int i = 0; i < [debtList count]; i ++) {
        NSMutableDictionary *debtDict = [debtList objectAtIndex:i];
        long friendId = [[debtDict objectForKey:@"friendId"] longValue];
        double myDebts = [[debtDict objectForKey:@"debtAmount"] doubleValue];
        int counter = i + 1;
        while(true){
            if(counter >= [debtList count])
                break;
            NSDictionary *innerDebtDict = [debtList objectAtIndex:counter];
            if([[innerDebtDict objectForKey:@"friendId"] longValue] == friendId){
                myDebts += [[innerDebtDict objectForKey:@"debtAmount"] floatValue];
                [debtDict setObject:[NSNumber numberWithDouble:myDebts] forKey:@"debtAmount"];
                [debtList removeObjectAtIndex:counter];
                continue;
            }
            counter ++;
        }
    }
    return debtList;
}
#pragma mark -
#pragma mark IBAction

-(IBAction)toggleSwitch:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_container setMenuState:MFSideMenuStateLeftMenuOpen];
    });
}

-(void)viewDidDisappear:(BOOL)animated{
    _container.panMode = MFSideMenuPanModeNone;
    [followOperationOwe cancel];
}


#pragma mark -
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_friendsArray count] + [oweArray count] + [debtArray count];
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
            UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
            [panRecognizer setMinimumNumberOfTouches:1];
            [panRecognizer setMaximumNumberOfTouches:1];
            [cell addGestureRecognizer:panRecognizer];
    }
    if(indexPath.row < [oweArray count]){
        Debt *debt = [oweArray objectAtIndex:indexPath.row];
        
        cell.friendLabel.text = debt.friendName;
        cell.moneyLabel.text = [NSString stringWithFormat:@"$%@", debt.debtAmount];
        cell.textColor = [UIColor whiteColor];
        cell.friendLabel.shadowColor = [UIColor whiteColor];
        cell.overLayView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:144.0/255.0 blue:199.0/255.0 alpha:0.35];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 58, cell.contentView.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        
        [cell.contentView addSubview:lineView];
        return cell;
    }else if(indexPath.row + [oweArray count] < [debtArray count]){
        Debt *debt = [debtArray objectAtIndex:indexPath.row - [oweArray count]];
        
        cell.friendLabel.text = debt.friendName;
        cell.moneyLabel.text = [NSString stringWithFormat:@"$%@", debt.debtAmount];
        cell.textColor = [UIColor whiteColor];
        cell.friendLabel.shadowColor = [UIColor whiteColor];
        cell.overLayView.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:144.0/255.0 blue:199.0/255.0 alpha:0.35];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 58, cell.contentView.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        
        [cell.contentView addSubview:lineView];
        return cell;

    }

    NSDictionary *theDictionary = [_friendsArray objectAtIndex:indexPath.row - [oweArray count] - [debtArray count]];
    Friend *friend = [theDictionary objectForKey:@"friend"];
    
    cell.friendLabel.text = friend.fullName;
    cell.moneyLabel.text = [NSString stringWithFormat:@"$%@", [theDictionary objectForKey:@"money"]];
    cell.textColor = [UIColor whiteColor];
    cell.friendLabel.shadowColor = [UIColor whiteColor];
    cell.overLayView.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:144.0/255.0 blue:199.0/255.0 alpha:0.35];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 58, cell.contentView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    
    [cell.contentView addSubview:lineView];

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
    
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        
        // Get the location of our touch, this time in the context of the superview.
        CGPoint location = [gesture locationInView:self.view];
        if(initialPosition == -1){
            initialPosition = location.x;
        }
        CGRect cellView = CGRectMake(-(initialPosition - location.x), 0, 320, 60);
        cell.overLayView.frame = cellView;
        
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [gesture locationInView:self.view];
        initialPosition = -1;
        if(location.x < 100)
        {
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
