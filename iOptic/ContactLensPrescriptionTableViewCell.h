//
//  ContactLensPrescriptionTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 03/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactLensPrescriptionTableViewCell;
@class RightImagedButton;

@protocol ContactLensPrescriptionTableViewCellDelegate <NSObject>

-(void)selectButtonTapped:(id)sender;

- (void)powerHelp:(id)sender;
- (void)bcHelp:(id)sender ;
- (void)diaHelp:(id)sender;
- (void)powerTapped:(id)sender ;
- (void)bcTapped:(id)sender ;
- (void)diaTapped:(id)sender ;
- (void)addHelpTapped:(id)sender ;
- (void)contactLensAxisHelpTapped:(id)sender ;
- (void)contactLensAddTapped:(id)sender ;
- (void)contactLensAxisTapped:(id)sender ;
@end

@interface ContactLensPrescriptionTableViewCell : UITableViewCell

@property(weak) id <ContactLensPrescriptionTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *cylinderOrAddLabel;
@property (weak, nonatomic) IBOutlet UIButton *axisInfoBtn;
@property (weak, nonatomic) IBOutlet UILabel *axisLabel;

@property (weak, nonatomic) IBOutlet RightImagedButton *powerRightBtn;

@property (weak, nonatomic) IBOutlet RightImagedButton *powerLeftBtn;

@property (weak, nonatomic) IBOutlet RightImagedButton *bcRightBtn;



@property (weak, nonatomic) IBOutlet RightImagedButton *bcLeftBtn;

@property (weak, nonatomic) IBOutlet RightImagedButton *diaLeftBtn;



@property (weak, nonatomic) IBOutlet RightImagedButton *diaRightBtn;


@property (weak, nonatomic) IBOutlet RightImagedButton *cylinderOrAddRigthBtn;

@property (weak, nonatomic) IBOutlet RightImagedButton *cylinderOrAddLefthBtn;


@property (weak, nonatomic) IBOutlet RightImagedButton *axisRigthBtn;

@property (weak, nonatomic) IBOutlet RightImagedButton *axisLeftBtn;



@end
