//
//  LensTypeTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RightImagedButton;

@protocol LensTypeTableViewCellDelegate <NSObject>
-(void)selectedSpecialGlass:(NSString*)selected;
-(void)deSelectedSpecialGlass:(NSString*)deSelected;

@end


@interface LensTypeTableViewCell : UITableViewCell

@property(weak) id <LensTypeTableViewCellDelegate> delegate;
@property(strong) NSArray *specialGlasses;

@end
