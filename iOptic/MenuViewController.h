//
//  MenuViewController.h
//  XLPagerTabStrip
//
//  Created by Satyanarayana Chebrolu on 9/10/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

-(void)menuViewController:(MenuViewController *)menuVC didSelectMenuItem:(MenuItem*)menuItem;

@end

@interface MenuViewController : UIViewController
@property(nonatomic) NSMutableArray<MenuItem*> *menuItemList;
@property(nonatomic, weak) id<MenuViewControllerDelegate> delegate;
@end
