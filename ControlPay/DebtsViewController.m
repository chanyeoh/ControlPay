//
//  DebtsViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 5/10/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "DebtsViewController.h"
#import "SlideCell.h"
#import "backgroundDesignViewController.h"

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "ConstantVariables.h"
#import "DebtsCell.h"
#import "Debt.h"
#import "UIImage+StackBlur.h"

@interface DebtsViewController ()

@end

@implementation DebtsViewController

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
    start = true;
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[backgroundDesignViewController blur:1.5f withImage:[UIImage imageNamed:@"wallpapers5.jpg"]]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //StackBlur Option Background;
    imagePreview.image=[[UIImage imageNamed:@"wowWallpaper5.jpg"] stackBlur:75];
    
    [self getDebtConnection];
    [self getOweConnection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)segmentChange:(id)sender{
    [debtsTableView reloadData];
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
#pragma mark Connection Data
-(void)getDebtConnection{
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
        
        debtsList = [[NSMutableArray alloc] init];
        NSMutableArray *myDebtsArray = [self combineExtraData: [debtList mutableCopy]];
        for (NSDictionary *debtDict in myDebtsArray) {
            Debt *debt = [[Debt alloc]init];
            [debt updateContext:debtDict];
            [debtsList addObject:debt];
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:debtsList];
        [userDefaults setObject:data forKey:@"debtsArray"];
        [userDefaults synchronize];
        [debtsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"%@", error);
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"debtsArray"];
        debtsList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [debtsTableView reloadData];
    }];
    
    [followOperation start];
}

-(void)getOweConnection{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AFHTTPClient *httpClientFollower = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClientFollower requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"%@%@/%@", BASE_URL, OWE_DEBTS,[userDefaults objectForKey:@"id"]]
                                                              parameters:nil];
    
    AFHTTPRequestOperation *followOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClientFollower registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [followOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSError *e = nil;
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *debtList = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        [userDefaults setObject:jsonString forKey:@"oweArray"];
        
        oweList = [[NSMutableArray alloc] init];
        NSMutableArray *myDebtsArray = [self combineExtraData: [debtList mutableCopy]];
        for (NSDictionary *debtDict in myDebtsArray) {
            Debt *debt = [[Debt alloc]init];
            [debt updateContext:debtDict];
            [oweList addObject:debt];
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:oweList];
        [userDefaults setObject:data forKey:@"oweArray"];
        [userDefaults synchronize];
        
        [debtsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"%@", error);
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"oweArray"];
        oweList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [debtsTableView reloadData];
    }];
    
    [followOperation start];
}


-(NSMutableArray *)combineExtraData:(NSMutableArray *)debtList{
    for (int i = 0; i < [debtList count]; i ++) {
        NSMutableDictionary *debtDict = [debtList objectAtIndex:i];
        long friendId = [[debtDict objectForKey:@"friendId"] longValue];
        double myDebts = [[debtDict objectForKey:@"debtAmount"] doubleValue];
        int count = i + 1;
        while(true){
            if(count >= [debtList count])
                break;
            NSDictionary *innerDebtDict = [debtList objectAtIndex:count];
            if([[innerDebtDict objectForKey:@"friendId"] longValue] == friendId){
                myDebts += [[innerDebtDict objectForKey:@"debtAmount"] floatValue];
                [debtDict setObject:[NSNumber numberWithDouble:myDebts] forKey:@"debtAmount"];
                [debtList removeObjectAtIndex:count];
                continue;
            }
            count ++;
        }
    }
    return debtList;
}
#pragma mark -
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return segmentControl.selectedSegmentIndex == 0 ? [debtsList count] : [oweList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DebtsCell";
    
    DebtsCell *cell = (DebtsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)		    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DebtsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];

    }
    NSMutableArray *currArray = segmentControl.selectedSegmentIndex == 0 ? debtsList : oweList;
    Debt *d = [currArray objectAtIndex:indexPath.row];
    cell.friendLabel.text = d.friendName;
    cell.priceLabel.text = [NSString stringWithFormat:@"$%@", d.debtAmount];
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        CGRect cellView = CGRectMake(0, 0, 320, 60);
        cell.overLayView.frame = cellView;
    }
}
@end
