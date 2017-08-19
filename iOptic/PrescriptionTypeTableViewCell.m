//
//  PrescriptionTypeTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "PrescriptionTypeTableViewCell.h"
#import "iOptic-Swift.h"

@implementation PrescriptionTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectButtonTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    btn.tag = 55;
    [self.delegate selectButtonTapped:sender];
}


@end
