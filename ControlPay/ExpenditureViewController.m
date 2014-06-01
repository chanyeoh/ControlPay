//
//  ExpenditureViewController.m
//  ControlPay
//
//  Created by Yeoh Chan on 5/9/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import "ExpenditureViewController.h"
#import "ExpenditureCell.h"
#import "backgroundDesignViewController.h"

#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "ConstantVariables.h"
#import "Expenditure.h"
#import "UIImage+StackBlur.h"

@interface ExpenditureViewController ()

@end

@implementation ExpenditureViewController
{
    NSArray * labelItems;
    NSArray *imageIcons;
    NSArray *myCatagories;
    NSMutableArray *expenditureNumbers;
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
    expenditureArray = [[NSArray alloc]initWithObjects:@"Expenditures", @"Debts", nil];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[backgroundDesignViewController blur:10.5f withImage:[UIImage imageNamed:@"wallpapers5.jpg"]]];
    imagePreview.image=[[UIImage imageNamed:@"sliderBack.jpg"] stackBlur:75];
    labelItems = [NSArray arrayWithObjects:@"expensesItem.png",@"incomesItem.png",nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forBarMetrics:UIBarMetricsDefault];
    
    imageIcons = [NSArray arrayWithObjects:@"transportationIcon.png", @"foodIcon.png", @"educationIcon.png", @"partyIcon.png" ,@"personalIcon.png",@"groceriesIcon.png",nil];
    myCatagories = [NSArray arrayWithObjects:@"Transportation", @"Food",@"Books", @"Entertainment", @"Personal",@"Groceries", nil];
    _container.panMode = MFSideMenuPanModeDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AFHTTPClient *httpClientFollower = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClientFollower requestWithMethod:@"GET"
                                                                    path:[NSString stringWithFormat:@"%@%@/%@", BASE_URL, GET_EXPENDITURE,[userDefaults objectForKey:@"id"]]
                                                              parameters:nil];
    
    AFHTTPRequestOperation *followOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClientFollower registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [followOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSError *e = nil;
        NSArray *expenditureList = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        NSMutableArray *expenditureModelList = [[NSMutableArray alloc] init];
        for (NSDictionary *objDict in expenditureList) {
            Expenditure *exp = [[Expenditure alloc]init];
            [exp updateContext:objDict];
            [expenditureModelList addObject: exp];
        }
        
        // Store Objects
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:expenditureModelList];
        [userDefaults setObject:data forKey:@"expenditureArray"];
        
        [self loopData: expenditureModelList];
        
        
        [userDefaults synchronize];
        //pendingButton.title = [NSString stringWithFormat:@"Pending (%d)", pendingCounter];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *expenditureModelList = [[NSUserDefaults standardUserDefaults] objectForKey:@"expenditureArray"];
        NSArray *expenditures = [NSKeyedUnarchiver unarchiveObjectWithData:expenditureModelList];
        [self loopData: [expenditures mutableCopy]];
    }];
    
    [followOperation start];
    _container.panMode = MFSideMenuPanModeDefault;
}


-(void)loopData:(NSMutableArray *)expenditureModelList{
    // Loop Data
    NSArray *categories = [[NSArray alloc]initWithObjects:@"Transportation", @"Food", @"Books", @"Entertainment", @"Personal", @"Groceries", nil];
    expenditureNumbers = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
    //for(int i =0; i < expenditureModelList.length; i ++){
    // Expenditure *exp = [expenditureMoeList objectAtIndex: i];
    for (Expenditure *exp in expenditureModelList)
    {
        for(int i = 0; i < [categories count]; i ++)
        {
            if([exp.category isEqualToString:[categories objectAtIndex:i]])
            {
                //NSLog(@"%@, %@", exp.category, [[expenditureNumbers objectAtIndex:i] stringValue]);
                float amountVal = [[expenditureNumbers objectAtIndex:i] floatValue] + [exp.amount floatValue];
                [expenditureNumbers setObject:[NSNumber numberWithFloat: amountVal] atIndexedSubscript:i];
                break;
            }
            
        }
     NSLog(@"%@, %@", exp.category, exp.amount);
    }
    
    NSLog(@"%@, %@", [categories objectAtIndex:2],[[expenditureNumbers objectAtIndex:2] stringValue]);
}

#pragma mark -
#pragma mark IBActions
-(IBAction)toggleSwitch:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_container setMenuState:MFSideMenuStateLeftMenuOpen];
    });
}

-(void)viewDidDisappear:(BOOL)animated{
    _container.panMode = MFSideMenuPanModeNone;
}

#pragma mark -
#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [myCatagories count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ExpenditureCell";
    
    ExpenditureCell *cell = (ExpenditureCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)		    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpenditureCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    
    [cell.contentView addSubview:lineView];
    
    cell.nameLabel.text = [myCatagories objectAtIndex:indexPath.row];
    NSLog(@"%@",[expenditureNumbers objectAtIndex:indexPath.row]);
    cell.amountLabel.text = [expenditureNumbers objectAtIndex:indexPath.row];
    //cell.imageProperty.image = [UIImage imageNamed:@"slider.png"];
    cell.backgroundColor = [UIColor clearColor];
    cell.imageProperty.image = [UIImage imageNamed:[imageIcons objectAtIndex:indexPath.row]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
