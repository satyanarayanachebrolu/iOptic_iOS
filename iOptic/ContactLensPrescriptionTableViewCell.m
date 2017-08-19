//
//  ContactLensPrescriptionTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 03/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "ContactLensPrescriptionTableViewCell.h"
#import "iOptic-Swift.h"


@implementation ContactLensPrescriptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)selectButton:(id)sender {
    [self.delegate selectButtonTapped:sender];
}


- (IBAction)powerHelp:(id)sender {
    [self.delegate powerHelp:sender];

}


- (IBAction)bcHelp:(id)sender {
    
    [self.delegate bcHelp:sender];
}

- (IBAction)diaHelp:(id)sender {
    [self.delegate diaHelp:sender];

}

- (IBAction)powerTapped:(id)sender {
    [self.delegate powerTapped:sender];

}

- (IBAction)bcTapped:(id)sender {
    [self.delegate bcTapped:sender];

}
- (IBAction)diaTapped:(id)sender {
    [self.delegate diaTapped:sender];

}
- (IBAction)contactLensAddHelpTapped:(id)sender {
    [self.delegate addHelpTapped:sender];

}

- (IBAction)contactLensAxisHelpTapped:(id)sender {
    [self.delegate contactLensAxisHelpTapped:sender];

}

- (IBAction)addTapped:(id)sender { // cylinder or add tapped
    [self.delegate contactLensAddTapped:sender];

}

- (IBAction)axisTapped:(id)sender { // axis tapped left and right
    [self.delegate contactLensAxisTapped:sender];

}







@end
