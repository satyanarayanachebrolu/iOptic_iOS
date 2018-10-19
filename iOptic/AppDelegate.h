//
//  AppDelegate.h
//  iOptic
//
//  Created by Satyanarayana Chebrolu on 5/23/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;
@import GoogleSignIn;
@class SwiftyOnboardVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong) NSMutableArray *firstGIF;
@property(strong) NSMutableArray *secondGIF;
@property(strong) NSMutableArray *thirdGIF;
@property(strong) SwiftyOnboardVC *walkthough;

-(void)goToMainViewController;
-(void)showLoginScreen;
@end

