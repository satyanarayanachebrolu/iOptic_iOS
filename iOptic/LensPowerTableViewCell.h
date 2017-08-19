//
//  LensPowerTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LensPowerTableViewCell;
@class RightImagedButton;

@protocol LensPowerTableViewCellDelegate <NSObject>

- (void)sphereHelpTapped:(id)sender;
- (void)cylinderHelpTapped:(id)sender;
- (void)rightSphereTapped:(id)sender;
- (void)leftSphereTapped:(id)sender;
- (void)regularLensRightCylinderTapped:(id)sender;
- (void)regularLensLeftCylinderTapped:(id)sender ;

@end

@interface LensPowerTableViewCell : UITableViewCell

@property(weak) id <LensPowerTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet RightImagedButton *sphereRightBtn;


@property (weak, nonatomic) IBOutlet RightImagedButton *sphereLeftBtn;


@property (weak, nonatomic) IBOutlet RightImagedButton *cylinderRightBtn;


@property (weak, nonatomic) IBOutlet RightImagedButton *cylinderLeftBtn;





@end
