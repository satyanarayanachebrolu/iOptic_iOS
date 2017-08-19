//
//  PrescriptionDetailsViewTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 09/07/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "PrescriptionDetailsViewTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PrescriptionDetailsViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.containerForLabels.layer setCornerRadius:5.0f];
    
    [self.containerForLabels.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.containerForLabels.layer setBorderWidth:1.5f];

    [self.containerForLabels.layer setShadowColor:[UIColor blackColor].CGColor];

    [self.containerForLabels.layer setShadowOpacity:0.8];
    
    [self.containerForLabels.layer setShadowRadius:3.0];

    [self.containerForLabels.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

    [self addGradientToBGDarkGradientView];
}

-(void)addGradientToBGDarkGradientView {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.bgDarkGradientView.bounds;
    gradient.colors = @[(id)[UIColor colorWithRed:(1.0/255.0) green:(170.0/255.0) blue:(194.0/255.0) alpha:1.0].CGColor, (id)[UIColor colorWithRed:(0.0/255.0) green:(133.0/255.0) blue:(119.0/255.0) alpha:1.0].CGColor];
    
    [self.bgDarkGradientView.layer insertSublayer:gradient atIndex:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
