//
//  AppDelegate.m
//  iOptic
//
//  Created by Satyanarayana Chebrolu on 5/23/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "AppDelegate.h"
#import "LGSideMenuController.h"
#import "iOptic-Swift.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "UIViewController+Alerts.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@import Firebase;
@import GoogleSignIn;

@interface AppDelegate ()<SwiftyOnboardVCDelegate>
@property(nonatomic) NSInteger currentOnBoardVCIndex;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];
    

    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    IQKeyboardManager.sharedManager.enable = YES;

    [FIRApp configure];
    
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].delegate = self;
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    
    _walkthough = [[SwiftyOnboardVC alloc] init];
    _walkthough.hideStatusBar = YES;
    _walkthough.showPageControl = YES;
    _walkthough.delegate = self;

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"splash" ofType:@"mp4"];
    if (moviePath)
    {
        AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
        controller.showsPlaybackControls = NO;
        //controller.view.frame = [UIScreen mainScreen].bounds;
        self.window.rootViewController = controller;
        controller.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSURL* movieURL = [NSURL fileURLWithPath:moviePath];
            AVPlayer *player = [AVPlayer playerWithURL:movieURL];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueWithLaunch) name: AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
            controller.player = player;
            [player play];
        });
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
        
        [navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"ViewController"]]];
        
        LGSideMenuController *sideMenuController = [LGSideMenuController new];
        sideMenuController.rootViewController = navigationController;
        sideMenuController.leftViewController = [storyboard instantiateViewControllerWithIdentifier:@"iOpticLeftMenuViewController"];
        
        sideMenuController.leftViewWidth = 300;
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        window.rootViewController = sideMenuController;
        
        
        [UIView transitionWithView:window
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:nil
                        completion:nil];
        
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




- (BOOL)application:(nonnull UIApplication *)application
            openURL:(nonnull NSURL *)url
            options:(nonnull NSDictionary<NSString *, id> *)options {
    return [self application:application
                     openURL:url
           sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                  annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[GIDSignIn sharedInstance] handleURL:url
                            sourceApplication:sourceApplication
                                   annotation:annotation]) {
        return YES;
    }
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];

    
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    [FIRAnalytics logEventWithName:@"BTN_CLICK_GOOGLE_LOGIN"
                        parameters:@{
                                     kFIRParameterItemID:@"BTN_CLICK_GOOGLE_LOGIN",
                                     kFIRParameterItemName:@"GOOGLE LOGIN",
                                     kFIRParameterContentType:@"text"
                                     }];

    
    LoginViewController *controller = (LoginViewController*) [GIDSignIn sharedInstance].uiDelegate;

    if (error != nil){
        [controller showMessagePrompt:error.localizedDescription];
    }
    else
    {
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:@"google" forKey:@"loginType"];
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                         accessToken:authentication.accessToken];
        
        [controller firebaseLogin:credential];

    }
}



- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    LoginViewController *controller = (LoginViewController*) [GIDSignIn sharedInstance].uiDelegate;
    
    if (error != nil){
        [controller showMessagePrompt:error.localizedDescription];
    }

    
    // Perform any operations when the user disconnects from app here.
    // ...
}




-(void)continueWithLaunch
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isTutorialShown"] boolValue]){
        
        FIRUser *user = [FIRAuth auth].currentUser;
        BOOL emailVerified = NO;
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSString *loginType = [userdefaults objectForKey:@"loginType"];
        if(user)
        {
            if([loginType isEqualToString:@"email"])
            {
                emailVerified = user.isEmailVerified;
            }
            else
            {
                emailVerified = YES;
            }
        }

        if(emailVerified)
        {
            [self goToMainViewController];
        }
        else
        {
            [self showLoginScreen];
        }
    }else{
        [self showTutorial];
    }
}

-(void)showTutorial
{
    UIStoryboard *onBoardStoryBoard = [UIStoryboard storyboardWithName:@"OnBoard" bundle:nil];
    FirstOnBoardViewController *firstViewController = [onBoardStoryBoard instantiateViewControllerWithIdentifier:@"FirstOnBoardScene"];
    [firstViewController playAnimation];
    
    SecondOnBoardViewController *secondViewController = [onBoardStoryBoard instantiateViewControllerWithIdentifier:@"SeondOnBoardScene"];
    [secondViewController playAnimation];

    ThirdOnBoardViewController *thirdViewController = [onBoardStoryBoard instantiateViewControllerWithIdentifier:@"ThirdOnBoardScene"];
    [thirdViewController playAnimation];

    _walkthough.viewControllers = @[firstViewController,secondViewController,thirdViewController];
    self.window.backgroundColor = [UIColor greenColor];
    
    _walkthough.bounces = NO;
    _walkthough.showLeftButton = NO;
    _walkthough.showRightButton = NO;
    _walkthough.showHorizontalScrollIndicator = YES;
    self.window.rootViewController = _walkthough;
    self.currentOnBoardVCIndex = 0;
}


- (void)pageDidChangeWithCurrentPage:(NSInteger)currentPage
{
    NSInteger vcIndex = currentPage-1;
    if(self.currentOnBoardVCIndex != vcIndex)
    {
        id<OnBoardPlayAnimation> vc = _walkthough.viewControllers[vcIndex];
        [vc playAnimation];
        self.currentOnBoardVCIndex = vcIndex;
    }
}


-(void)showLoginScreen
{
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *loginViewController = [loginStoryboard instantiateInitialViewController];
    self.window.rootViewController = loginViewController;
}


-(void)goToMainViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    [navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"ViewController"]]];
    
    LGSideMenuController *sideMenuController = [LGSideMenuController new];
    sideMenuController.rootViewController = navigationController;
    sideMenuController.leftViewController = [storyboard instantiateViewControllerWithIdentifier:@"iOpticLeftMenuViewController"];
    
    sideMenuController.leftViewWidth = 300;
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = sideMenuController;
    
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}


@end
