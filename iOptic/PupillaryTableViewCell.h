//
//  PupillaryTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum pdSelectionTypes
{
    SINGLE_PD_SELECTED,
    DUAL_PD_SELECTED
} PDSelctionType;

@class PupillaryTableViewCell;
@class RightImagedButton;

@protocol PupillaryTableViewCellDelegate <NSObject>

-(void)pupillarySelected:(PDSelctionType)type cell:(PupillaryTableViewCell*)cell;

- (void)rightPDSelected:(id)sender;
- (void)leftPDSelected:(id)sender ;
-(void)pupillaryHelpTapped:(id)sender;

@end

@interface PupillaryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *pdTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *singlePDBtn;
@property(nonatomic,weak) id <PupillaryTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *dualPDBtn;



@property (weak, nonatomic) IBOutlet RightImagedButton *rightPDBtn;


@property (weak, nonatomic) IBOutlet RightImagedButton *leftPDBtn;




@end
