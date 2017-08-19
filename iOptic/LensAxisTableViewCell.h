//
//  LensAxisTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LensAxisTableViewCell;
@class RightImagedButton;


@protocol LensAxisTableViewCellDelegate <NSObject>

- (void)axisHelpTapped:(id)sender;
- (void)addHelpTapped:(id)sender;
- (void)rightAxisTapped:(id)sender ;
- (void)leftAxisTapped:(id)sender ;
- (void)regularLensAddTapped:(id)sender ;
@end
@interface LensAxisTableViewCell : UITableViewCell

@property(weak) id <LensAxisTableViewCellDelegate> delegate;


@property (weak, nonatomic) IBOutlet RightImagedButton *lensAxisRigthBtn;

@property (weak, nonatomic) IBOutlet RightImagedButton *lensAxisLeftBtn;

@property (weak, nonatomic) IBOutlet RightImagedButton *lensAddRigthBtn;


@property (weak, nonatomic) IBOutlet RightImagedButton *lensAddLeftBtn;



@end
