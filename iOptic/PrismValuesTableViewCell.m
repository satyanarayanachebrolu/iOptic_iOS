//
//  PrismValuesTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "PrismValuesTableViewCell.h"

#import "iOptic-Swift.h"


@implementation PrismValuesTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)prismYesTapped:(id)sender {
    if(![sender isSelected]){
        [self.yesBtn setImage:[UIImage imageNamed:@"select_check-mark"] forState:UIControlStateSelected];
        [sender setSelected:YES];
    }else{
        [self.yesBtn setImage:[UIImage imageNamed:@"unselected_radiobutton"] forState:UIControlStateSelected];
        [sender setSelected:NO];

    }
    [self.delegate prismValueSelected:YES cell:self];
}

- (IBAction)prismNoTapped:(id)sender {
//    if(![sender isSelected]){
//        [self.yesBtn setImage:[UIImage imageNamed:@"select_check-mark"] forState:UIControlStateSelected];
//        [sender setSelected:YES];
//    }else{
//        [self.yesBtn setImage:[UIImage imageNamed:@"unselected_radiobutton"] forState:UIControlStateSelected];
//        [sender setSelected:NO];
//        
//    }
   [self.delegate prismValueSelected:NO cell:self];
}

- (IBAction)prismRightTapped:(id)sender {
    [self.delegate prismRightTapped:sender];
}
- (IBAction)prismLeftTapped:(id)sender {
    [self.delegate prismLeftTapped:sender];

}
- (IBAction)prismBaseRightTapped:(id)sender {
    [self.delegate prismBaseRightTapped:sender];

}

- (IBAction)prismBaseLeftTapped:(id)sender {
    [self.delegate prismBaseLeftTapped:sender];

}

- (IBAction)prismHelpTapped:(id)sender {
    [self.delegate prismHelpTapped:sender];

}





@end
