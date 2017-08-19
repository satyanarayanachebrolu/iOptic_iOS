//
//  PrescriptionTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 27/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "PrescriptionTableViewCell.h"
#import "iOptic-Swift.h"


@implementation PrescriptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.layer.cornerRadius=10; //set corner radius here
//    self.layer.borderColor = [UIColor grayColor].CGColor ; // set cell border color here
//    self.layer.borderWidth = 1; // set border width here
//    self.layer.masksToBounds = YES;
    
    [self.containerForLabels.layer setCornerRadius:8.0f];
    
    [self.containerForLabels.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.containerForLabels.layer setBorderWidth:0.2f];
    
    [self.containerForLabels.layer setShadowColor:[UIColor blackColor].CGColor];
    
    [self.containerForLabels.layer setShadowOpacity:0.8];
    
    [self.containerForLabels.layer setShadowRadius:8.0];
    
    [self.containerForLabels.layer setShadowOffset:CGSizeMake(3.0, 3.0)];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
