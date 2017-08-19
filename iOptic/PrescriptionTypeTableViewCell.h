//
//  PrescriptionTypeTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrescriptionTypeTableViewCell;
@class RightImagedButton;

@protocol PrescriptionTypeTableViewCellDelegate <NSObject>

-(void)selectButtonTapped:(id)sender;

@end

@interface PrescriptionTypeTableViewCell : UITableViewCell

@property(weak) id <PrescriptionTypeTableViewCellDelegate> delegate;


@property (weak, nonatomic) IBOutlet RightImagedButton *prescriptionTypeBtn;

@end
