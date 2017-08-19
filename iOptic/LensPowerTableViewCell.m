//
//  LensPowerTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "LensPowerTableViewCell.h"

#import "iOptic-Swift.h"


@implementation LensPowerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)sphereHelpTapped:(id)sender {
    [self.delegate sphereHelpTapped:sender];
    
}

- (IBAction)cylinderHelpTapped:(id)sender {
    [self.delegate cylinderHelpTapped:sender];
}
- (IBAction)rightSphereTapped:(id)sender {
    [self.delegate rightSphereTapped:sender];
}
- (IBAction)leftSphereTapped:(id)sender {
    [self.delegate leftSphereTapped:sender];
}

- (IBAction)rightCylinderTapped:(id)sender {
    [self.delegate regularLensRightCylinderTapped:sender];
}

- (IBAction)leftCylinderTapped:(id)sender {
    [self.delegate regularLensLeftCylinderTapped:sender];

}


@end
