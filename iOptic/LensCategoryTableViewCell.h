//
//  LensCategoryTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 03/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LensCategoryTableViewCell;
@class RightImagedButton;


@protocol LensCategoryTableViewCellDelegate <NSObject>

-(void)contactLensCategory:(BOOL)isSelected cell:(LensCategoryTableViewCell*)cell;
-(void)regularLensCategory:(BOOL)isSelected cell:(LensCategoryTableViewCell*)cell;

@end

@interface LensCategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lensCategoryLabel;

@property (weak, nonatomic) IBOutlet UIButton *contactlensBtn;
@property (weak, nonatomic) IBOutlet UIButton *regularLensBtn;


@property(nonatomic,weak) id <LensCategoryTableViewCellDelegate> delegate;

@end
