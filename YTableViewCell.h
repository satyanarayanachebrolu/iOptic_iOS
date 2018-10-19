//
//  YTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 11/07/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *powerRight;
@property (weak, nonatomic) IBOutlet UILabel *lensTypeLbl;

@property (weak, nonatomic) IBOutlet UIView *containerForLabels;

@property (weak, nonatomic) IBOutlet UILabel *powerLeft;

@property (weak, nonatomic) IBOutlet UILabel *bcRight;

@property (weak, nonatomic) IBOutlet UILabel *bcLeft;


@property (weak, nonatomic) IBOutlet UILabel *diaRight;
@property (weak, nonatomic) IBOutlet UILabel *diaLeft;

@property (weak, nonatomic) IBOutlet UILabel *diaRightBioView;
@property (weak, nonatomic) IBOutlet UILabel *diaLeftBioView;


@property (weak, nonatomic) IBOutlet UILabel *cylinderRight;
@property (weak, nonatomic) IBOutlet UILabel *axisLeft;

@property (weak, nonatomic) IBOutlet UILabel *axisRight;


@property (weak, nonatomic) IBOutlet UILabel *cylinderLeft;


@property (weak, nonatomic) IBOutlet UILabel *addRightLbl;

@property (weak, nonatomic) IBOutlet UILabel *addLeftLbl;


@property (weak, nonatomic) IBOutlet UIView *bifocalContactsView;//shows dia and add
@property (weak, nonatomic) IBOutlet UIView *regularContactsView;//shows dia
@property (weak, nonatomic) IBOutlet UIView *astigmatismView;//shows Cylinder and Axis



-(void)updateDetails:(NSDictionary*)prescriptionDetails;
@end
