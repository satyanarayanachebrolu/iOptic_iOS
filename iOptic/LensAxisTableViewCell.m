//
//  LensAxisTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "LensAxisTableViewCell.h"
#import "iOptic-Swift.h"


@implementation LensAxisTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)axisHelpTapped:(id)sender {
    
    [self.delegate axisHelpTapped:sender];
}

- (IBAction)addHelpTapped:(id)sender {
    [self.delegate addHelpTapped:sender];
}
- (IBAction)rightAxisTapped:(id)sender {
    [self.delegate rightAxisTapped:sender];
}
- (IBAction)leftAxisTapped:(id)sender {
    [self.delegate leftAxisTapped:sender];
}

- (IBAction)rightAddTapped:(id)sender {
    [self.delegate regularLensAddTapped:sender];
}

- (IBAction)leftAddTapped:(id)sender {
    [self.delegate regularLensAddTapped:sender];
}



@end
