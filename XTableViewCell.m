//
//  XTableViewCell.m
//  Pods
//
//  Created by Santosh S on 7/10/17.
//
//

#import "XTableViewCell.h"

@implementation XTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.viewPupillary.layer setCornerRadius:0.0f];
    
    [self.viewPupillary.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.viewPupillary.layer setBorderWidth:1.f];
    
    [self.viewPupillaryValue.layer setCornerRadius:0.0f];
    
    [self.viewPupillaryValue.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.viewPupillaryValue.layer setBorderWidth:1.0f];
    
    
    [self.containerForLabels.layer setCornerRadius:5.0f];
    
    [self.containerForLabels.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.containerForLabels.layer setBorderWidth:1.5f];
    
    [self.containerForLabels.layer setShadowColor:[UIColor blackColor].CGColor];
    
    [self.containerForLabels.layer setShadowOpacity:0.8];
    
    [self.containerForLabels.layer setShadowRadius:3.0];
    
    [self.containerForLabels.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

}


-(void)updateCellDetails:(NSDictionary*)currentPrescriptionDict
{
    if ([currentPrescriptionDict valueForKey:@"type"]){
        self.lensType.text = [currentPrescriptionDict valueForKey:@"type"];
    }else{
        [self.lensType setHidden:YES];
    }
    
    if ([currentPrescriptionDict valueForKey:@"axis"]){
        self.axisRightValue.text = [[currentPrescriptionDict valueForKey:@"axis"] valueForKey:@"od"];
        self.axisLeftValue.text = [[currentPrescriptionDict valueForKey:@"axis"] valueForKey:@"os"];
    }
    if ([currentPrescriptionDict valueForKey:@"add"]){
        self.addRigthtValue.text = [[currentPrescriptionDict valueForKey:@"add"] valueForKey:@"od"];
        self.addLeftValue.text = [[currentPrescriptionDict valueForKey:@"add"] valueForKey:@"os"];
    }
    
    if ([currentPrescriptionDict valueForKey:@"sphere"]){
        self.sphereRightHeader.text = [[currentPrescriptionDict valueForKey:@"sphere"] valueForKey:@"od"];
        self.sphereLeftHeader.text = [[currentPrescriptionDict valueForKey:@"sphere"] valueForKey:@"os"];
    }
    if ([currentPrescriptionDict valueForKey:@"cylinder"]){
        self.cylinderRightLabel.text = [[currentPrescriptionDict valueForKey:@"cylinder"] valueForKey:@"od"];
        self.cylinderLeftLabel.text = [[currentPrescriptionDict valueForKey:@"cylinder"] valueForKey:@"os"];
    }else{
        
    }
    
    NSDictionary *prismValues = [currentPrescriptionDict valueForKey:@"prismValues"];
    if(prismValues)
    {
        self.prismBaseView.hidden = NO;
        if ([currentPrescriptionDict valueForKey:@"prismValues"]){
            self.prismRightValue.text = [[currentPrescriptionDict valueForKey:@"prismValues"] valueForKey:@"prismOd"];
            self.prismLeftValue.text = [[currentPrescriptionDict valueForKey:@"prismValues"] valueForKey:@"prismOs"];
        }
        if ([currentPrescriptionDict valueForKey:@"base"]){
            self.baseRigthtValue.text = [[currentPrescriptionDict valueForKey:@"base"] valueForKey:@"od"];
            self.baseLeftValue.text = [[currentPrescriptionDict valueForKey:@"base"] valueForKey:@"os"];
        }    }
    else
    {
        self.prismBaseView.hidden = YES;
    }
    
    
    if ([[currentPrescriptionDict valueForKey:@"isDualPd"] boolValue]){
        if ([[[currentPrescriptionDict valueForKey:@"pd"] valueForKey:@"dualPd"] valueForKey:@"os"] && [[[currentPrescriptionDict valueForKey:@"pd"] valueForKey:@"dualPd"] valueForKey:@"od"]){
            self.pupillaryRightValueLbl.text = [[[currentPrescriptionDict valueForKey:@"pd"] valueForKey:@"dualPd"] valueForKey:@"od"];
            self.pupillaryLeftValueLbl.text = [[[currentPrescriptionDict valueForKey:@"pd"] valueForKey:@"dualPd"] valueForKey:@"os"];
        }
    }
        else if([[currentPrescriptionDict valueForKey:@"pd"] valueForKey:@"singlePd"]){ // single PD
            self.pupillaryRightValueLbl.text = [[currentPrescriptionDict valueForKey:@"pd"] valueForKey:@"singlePd"];
            [self.dualPDView setHidden:YES];
            self.dualPDStaticLabel.hidden = YES;
            self.rightPDStaticLabel.text = @"pupillary distance (PD)";
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic"
                                           size:12.0f];
            [self.rightPDStaticLabel setFont:font];
        }
        else{
            [self.dualPDView setHidden:YES];
            self.dualPDStaticLabel.hidden = YES;
            self.rightPDView.hidden = YES;
        }
    
    NSArray *specialGlasses = [currentPrescriptionDict valueForKey:@"specialGlass"];
    UInt8 count = specialGlasses.count;
    if ([currentPrescriptionDict valueForKey:@"specialGlass"]){
        if ([[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:0]){
            [self.firstNote setHidden:NO];
            [self.firstImgView setHidden:NO];
            self.firstNote.text = [[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:0];
        }
        if (count > 1 &&[[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:1]){
            [self.secondNote setHidden:NO];
            [self.secondImgView setHidden:NO];
            self.secondNote.text = [[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:1];
        }
        if (count > 2 &&[[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:2]){
            [self.thirdImgView setHidden:NO];
            [self.thirdNote setHidden:NO];
            self.thirdNote.text = [[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:2];
        }
        if (count > 3 &&[[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:3]){
            [self.fourthNote setHidden:NO];
            [self.fourthImgView setHidden:NO];
            self.fourthNote.text = [[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:3];
        }
        if (count > 4&&[[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:4]){
            [self.fifthNote setHidden:NO];
            [self.fifthImgView setHidden:NO];
            self.fifthNote.text = [[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:4];
        }
        if (count>5 &&[[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:5]){
            [self.sixthNote setHidden:NO];
            [self.sixthImgView setHidden:NO];
            self.sixthNote.text = [[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:5];
        }
        if (count > 6&&[[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:6]){
            [self.sevenNote setHidden:NO];
            [self.sevenImgView setHidden:NO];
            self.sevenNote.text = [[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:6];
        }
        if (count > 7&&[[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:7]){
            [self.eightNotes setHidden:NO];
            [self.eightImgView setHidden:NO];
            self.eightNotes.text = [[currentPrescriptionDict valueForKey:@"specialGlass"] objectAtIndex:7];
        }
    }
    if(count == 0)
    {
        self.otherFeaturesLabel.hidden = YES;
    }
        
}

@end
