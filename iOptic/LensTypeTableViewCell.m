//
//  LensTypeTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "LensTypeTableViewCell.h"
#import "iOptic-Swift.h"


@implementation LensTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.specialGlasses = [NSArray arrayWithObjects:@"polycarbonite",@"single vision",@"anti reflective",@"high index plastic",@"scratch resistant",@"photo chromic",@"photo brown",@"uv protection", nil];
    // Configure the view for the selected state
}



- (IBAction)buttonAction:(id)sender {
    UIButton *button = (UIButton*)sender;
    if ([sender isSelected]){
        [sender setSelected:NO];
        [button setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [self.delegate deSelectedSpecialGlass:[self.specialGlasses objectAtIndex:button.tag-1]];
        
    }else{
        [button setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        [sender setSelected:YES];
        [self.delegate selectedSpecialGlass:[self.specialGlasses objectAtIndex:button.tag-1]];


    }
    
}



















@end
