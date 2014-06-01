//
//  ExpenditureCell.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/9/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenditureCell : UITableViewCell

@property(strong, nonatomic)IBOutlet UIImageView *imageProperty;
@property(strong, nonatomic)IBOutlet UILabel *nameLabel;
@property(strong, nonatomic)IBOutlet UILabel *amountLabel;

@end
