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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)singlePDTapped:(id)sender {
    [self.delegate pupillarySelected:SINGLE_PD_SELECTED cell:self];
}


- (IBAction)dualPDTapped:(id)sender {
    [self.delegate pupillarySelected:DUAL_PD_SELECTED cell:self];

}

- (IBAction)rightPDSelected:(id)sender {
    [self.delegate rightPDSelected:sender];
    
}
- (IBAction)leftPDSelected:(id)sender {
    
    [self.delegate leftPDSelected:sender];
    
}

- (IBAction)showPopupForPupillaryDistance:(id)sender {
    [self.delegate pupillaryHelpTapped:self];
    
}




@end
