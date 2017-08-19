//
//  DatePickerViewController.h
//  iOptic
//
//  Created by Santhosh on 02/08/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatePickerViewController;

@protocol DatePickerViewControllerDelegate <NSObject>

-(void)pickerViewController:(DatePickerViewController *)pv didSelectDate:(NSString *)date;

@end

@interface DatePickerViewController : UIViewController
@property(weak, nonatomic) id<DatePickerViewControllerDelegate> delegate;


@end
