//
//  TutorialContentViewController.h
//  iOptic
//
//  Created by Santhosh on 19/08/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (assign) NSUInteger pageIndex;
@property (strong) NSString *titleText;
@property (strong) NSString *headerText;

@property (strong) NSString *imageFile;
@property (weak, nonatomic) IBOutlet UIImageView *animatedImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;

@end
