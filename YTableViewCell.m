//
//  YTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 11/07/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "YTableViewCell.h"

@implementation YTableViewCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateDetails:(NSDictionary*)prescriptionDetails
{
    NSString *lensType = [prescriptionDetails valueForKey:@"contactType"];

    self.lensTypeLbl.text = lensType;
    if ([prescriptionDetails valueForKey:@"power"]){
        self.powerLeft.text = [[prescriptionDetails valueForKey:@"power"] valueForKey:@"os"];
        self.powerRight.text = [[prescriptionDetails valueForKey:@"power"] valueForKey:@"od"];
    }
    
    
    if ([prescriptionDetails valueForKey:@"bc"]){
        self.bcRight.text = [[prescriptionDetails valueForKey:@"bc"] valueForKey:@"od"];
        self.bcLeft.text = [[prescriptionDetails valueForKey:@"bc"] valueForKey:@"os"];
    }

    if([lensType isEqualToString:@"Regular Contacts"])
    {
        self.regularContactsView.hidden = NO;
        self.bifocalContactsView.hidden = YES;
        self.astigmatismView.hidden = YES;
    }
    else if([lensType isEqualToString:@"Bifocal Contacts"])
    {
        self.bifocalContactsView.hidden = NO;
        self.regularContactsView.hidden = YES;
        self.astigmatismView.hidden = YES;
        
        self.diaRightBioView.text = [[prescriptionDetails valueForKey:@"dia"] valueForKey:@"od"];
        self.diaLeftBioView.text = [[prescriptionDetails valueForKey:@"dia"] valueForKey:@"os"];
        
        if ([prescriptionDetails valueForKey:@"add"]){
            if ([[prescriptionDetails valueForKey:@"add"] valueForKey:@"od"]){
                self.addRightLbl.text = [[prescriptionDetails valueForKey:@"add"] valueForKey:@"od"];
            }        if ([[prescriptionDetails valueForKey:@"add"] valueForKey:@"os"]){
                self.addLeftLbl.text = [[prescriptionDetails valueForKey:@"add"] valueForKey:@"os"];
            }
        }


    }
    else if([lensType isEqualToString:@"Astigmatism"])
    {
        self.bifocalContactsView.hidden = YES;
        self.regularContactsView.hidden = NO;
        self.astigmatismView.hidden = NO;
        
        if ([prescriptionDetails valueForKey:@"axis"]){
            self.axisRight.text = [[prescriptionDetails valueForKey:@"axis"] valueForKey:@"od"];
            self.axisLeft.text = [[prescriptionDetails valueForKey:@"axis"] valueForKey:@"os"];
        }
        
        if ([prescriptionDetails valueForKey:@"cylinder"]){
            self.cylinderRight.text = [[prescriptionDetails valueForKey:@"cylinder"] valueForKey:@"od"];
            self.cylinderLeft.text = [[prescriptionDetails valueForKey:@"cylinder"] valueForKey:@"os"];
        }

    }
    else
    {
        NSLog(@"Something went wrong");
        assert(false);
    }
    
    
    if ([prescriptionDetails valueForKey:@"dia"]){
        self.diaRight.text = [[prescriptionDetails valueForKey:@"dia"] valueForKey:@"od"];
        self.diaLeft.text = [[prescriptionDetails valueForKey:@"dia"] valueForKey:@"os"];
    }
    
    
    
}
@end
