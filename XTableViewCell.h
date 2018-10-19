//
//  XTableViewCell.h
//  Pods
//
//  Created by Santosh S on 7/10/17.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface XTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sphereLeftHeader;

@property (weak, nonatomic) IBOutlet UILabel *sphereRightHeader;

@property (weak, nonatomic) IBOutlet UILabel *cylinderLeftLabel;

@property (weak, nonatomic) IBOutlet UILabel *cylinderRightLabel;

@property (weak, nonatomic) IBOutlet UILabel *axisRightValue;

@property (weak, nonatomic) IBOutlet UILabel *axisLeftValue;

@property (weak, nonatomic) IBOutlet UILabel *addRigthtValue;

@property (weak, nonatomic) IBOutlet UILabel *addLeftValue;

@property (weak, nonatomic) IBOutlet UILabel *prismRightValue;

@property (weak, nonatomic) IBOutlet UILabel *prismLeftValue;

@property (weak, nonatomic) IBOutlet UILabel *baseRigthtValue;

@property (weak, nonatomic) IBOutlet UILabel *baseLeftValue;

@property (weak, nonatomic) IBOutlet UILabel *lensType;

@property (weak, nonatomic) IBOutlet UIView *viewPupillary;
@property (weak, nonatomic) IBOutlet UIView *viewPupillaryValue;


@property (weak, nonatomic) IBOutlet UILabel *pupillaryLeftValueLbl;


@property (weak, nonatomic) IBOutlet UILabel *pupillaryRightValueLbl;

@property (weak, nonatomic) IBOutlet UIView *containerForLabels;

@property (weak, nonatomic) IBOutlet UIImageView *firstImgView;
@property (weak, nonatomic) IBOutlet UILabel *firstNote;
@property (weak, nonatomic) IBOutlet UIImageView *secondImgView;
@property (weak, nonatomic) IBOutlet UILabel *secondNote;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImgView;
@property (weak, nonatomic) IBOutlet UILabel *thirdNote;

@property (weak, nonatomic) IBOutlet UIImageView *fourthImgView;

@property (weak, nonatomic) IBOutlet UIImageView *fifthImgView;

@property (weak, nonatomic) IBOutlet UILabel *fourthNote;
@property (weak, nonatomic) IBOutlet UILabel *fifthNote;

@property (weak, nonatomic) IBOutlet UIImageView *sixthImgView;
@property (weak, nonatomic) IBOutlet UILabel *sixthNote;

@property (weak, nonatomic) IBOutlet UIImageView *sevenImgView;

@property (weak, nonatomic) IBOutlet UILabel *sevenNote;

@property (weak, nonatomic) IBOutlet UIImageView *eightImgView;

@property (weak, nonatomic) IBOutlet UILabel *eightNotes;

@property (weak, nonatomic) IBOutlet UIStackView *dualPDView;
@property (weak, nonatomic) IBOutlet UIStackView *rightPDView;

@property (weak, nonatomic) IBOutlet UILabel *rightPDStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *dualPDStaticLabel;
@property (weak, nonatomic) IBOutlet UIView *prismBaseView;
@property (weak, nonatomic) IBOutlet UILabel *otherFeaturesLabel;






-(void)updateCellDetails:(NSDictionary*)currentPrescriptionDict;
@end
