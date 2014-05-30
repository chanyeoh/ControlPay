//
//  ProfileCell.h
//  ControlPay
//
//  Created by Yeoh Chan on 5/17/14.
//  Copyright (c) 2014 Yeoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell
@property(strong,nonatomic)IBOutlet UILabel *titleText;
@property(strong,nonatomic)IBOutlet UILabel *priceText;
@property(strong,nonatomic)IBOutlet UIImageView *headingLabel;
@end
