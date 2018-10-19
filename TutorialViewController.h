//
//  TutorialViewController.h
//  iOptic
//
//  Created by Santhosh on 19/08/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController<UIPageViewControllerDataSource>


@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageDescriptions;
@property (strong, nonatomic) NSArray *pageImages;
- (void)navigateForward;
@end
