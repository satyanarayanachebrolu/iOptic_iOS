//
//  PrescriptionDetailsViewTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 09/07/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrescriptionDetailsViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameHeaderLbl;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UILabel *doctorNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@property (weak, nonatomic) IBOutlet UIView *bgDarkGradientView;

@property (weak, nonatomic) IBOutlet UIView *containerForLabels;

@end
