//
//  NotesTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "NotesViewTableViewCell.h"

@implementation NotesViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.containerForLabels.layer setCornerRadius:5.0f];
    
    [self.containerForLabels.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.containerForLabels.layer setBorderWidth:1.5f];
    
    [self.containerForLabels.layer setShadowColor:[UIColor blackColor].CGColor];
    
    [self.containerForLabels.layer setShadowOpacity:0.8];
    
    [self.containerForLabels.layer setShadowRadius:3.0];
    
    [self.containerForLabels.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
