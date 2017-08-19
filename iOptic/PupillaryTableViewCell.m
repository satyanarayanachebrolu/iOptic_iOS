//
//  PupillaryTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "PupillaryTableViewCell.h"
#import "iOptic-Swift.h"

@implementation PupillaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSLog(@"rightLabel %d",[self.rightLabel isHidden]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)singlePDTapped:(id)sender {
    [self.pdTitleLabel setText:@"select pd"];
    [self.rightLabel setHidden:YES];
    [self.delegate pupillarySelected:SINGLE_PD_SELECTED cell:self];
}


- (IBAction)dualPDTapped:(id)sender {
    [self.pdTitleLabel setText:@"pd"];
    [self.rightLabel setHidden:NO];
    [self.delegate pupillarySelected:DUAL_PD_SELECTED cell:self];

}

- (IBAction)rightPDSelected:(id)sender {
    [self.delegate rightPDSelected:sender];
    
}
- (IBAction)leftPDSelected:(id)sender {
    
    [self.delegate leftPDSelected:sender];
    
}



@end
