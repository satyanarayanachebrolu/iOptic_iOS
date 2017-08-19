//
//  PersonDetailsTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 07/07/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SkyFloatingLabelTextField;
@class RightImagedButton;


@interface PersonDetailsTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *nameLbl;
@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *doctorNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
