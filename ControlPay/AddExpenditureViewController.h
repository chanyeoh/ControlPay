//
//  AddExpenditureViewController.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/10/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddExpenditureViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    NSArray *myCategories;
    NSIndexPath *selectedIndexPath;
    IBOutlet UIImageView * imagePreview;
    IBOutlet UIButton *setButton;
    IBOutlet UIButton *addExpenses;
}
@property(strong, nonatomic)IBOutlet UICollectionView *collectionView;
@property(strong, nonatomic)IBOutlet UITextField *amountTextField;

-(IBAction)addButton:(id)sender;
-(IBAction)cancelEditingForView:(id)sender;

@end
