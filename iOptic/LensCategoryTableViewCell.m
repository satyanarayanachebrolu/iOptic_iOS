//
//  LensCategoryTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 03/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "LensCategoryTableViewCell.h"
#import "iOptic-Swift.h"


@implementation LensCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)contactLensTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if ([sender isSelected]){
       // self.isContactLensCategoryTapped = NO;
        [sender setSelected:NO];
        [btn setImage:[UIImage imageNamed:@"unchecked"]forState:UIControlStateNormal];
        [self.delegate contactLensCategory:NO cell:self];
        [self.lensCategoryLabel setTextColor:[UIColor colorWithRed:30/255.0 green:184.0/255.0 blue:207/255.0 alpha:1.0]];

        
        
        
    }else{
        //self.isContactLensCategoryTapped = YES;
        [sender setSelected:YES];
        [btn setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateSelected];
        [self.delegate contactLensCategory:YES cell:self];
        

    }
}

@end
