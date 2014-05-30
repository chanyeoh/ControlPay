//
//  SlideCell.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/10/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideCell : UITableViewCell
@property(strong,nonatomic)IBOutlet UIView *overLayView;
@property(strong,nonatomic)IBOutlet UILabel *friendLabel;
@property(strong,nonatomic)IBOutlet UILabel *moneyLabel;
@property(strong,nonatomic)IBOutlet UIButton *addButton;


@end
