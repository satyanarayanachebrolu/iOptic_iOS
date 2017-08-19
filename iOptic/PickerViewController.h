//
//  PickerViewController.h
//  XLPagerTabStrip
//
//  Created by Satyanarayana Chebrolu on 9/13/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerViewController;

@protocol PickerViewControllerDelegate <NSObject>

-(void)pickerViewController:(PickerViewController *)pv didSelectItem:(NSString *)item;

@end

@interface PickerViewController : UIViewController
@property(nonatomic) NSMutableArray *pickerList;
@property(weak, nonatomic) id<PickerViewControllerDelegate> delegate;
@end
