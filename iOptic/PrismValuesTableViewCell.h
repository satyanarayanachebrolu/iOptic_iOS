//
//  PrismValuesTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum prismSelection
{
    YES_SELECTED,
    NO_SELECTED,
    NONE
} PrismSelctionType;


@class PrismValuesTableViewCell;
@class RightImagedButton;

@protocol PrismValuesTableViewCellDelegate <NSObject>

-(void)prismValueSelected:(BOOL)yesOrNo cell:(PrismValuesTableViewCell*)cell;

- (void)prismRightTapped:(id)sender;
- (void)prismLeftTapped:(id)sender ;
- (void)prismBaseRightTapped:(id)sender;
- (void)prismBaseLeftTapped:(id)sender ;
- (void)prismHelpTapped:(id)sender;

@end




@interface PrismValuesTableViewCell : UITableViewCell

@property(nonatomic,weak) id <PrismValuesTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;

@property (weak, nonatomic) IBOutlet RightImagedButton *prismRightBtn;

@property (weak, nonatomic) IBOutlet RightImagedButton *prismLeftBtn;

@property (weak, nonatomic) IBOutlet RightImagedButton *baseRightBtn;

@property (weak, nonatomic) IBOutlet RightImagedButton *baseLeftBtn;

@end
