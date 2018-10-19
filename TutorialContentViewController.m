//
//  TutorialContentViewController.m
//  iOptic
//
//  Created by Santhosh on 19/08/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "TutorialContentViewController.h"
#import "LGSideMenuController.h"
#import "TutorialViewController.h"
#import "AppDelegate.h"

@interface TutorialContentViewController ()

@end

@implementation TutorialContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
   // [self performSelectorInBackground:@selector(doItInBg) withObject:nil];
   // self.button.titleLabel.text = self.titleText;
    [self doItInBg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)doItInBg
{
//    AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
//    if ([self.imageFile isEqualToString:@"1_"]){
//        self.animatedImageView.animationImages = appDelegate.firstGIF;
//
//    }else if([self.imageFile isEqualToString:@"2_"]){
//        self.animatedImageView.animationImages = appDelegate.secondGIF;
//    }else{
//        self.animatedImageView.animationImages = appDelegate.thirdGIF;
//    }
   
    
    self.headerLbl.text = self.headerText;
    self.animatedImageView.animationDuration = 1.5f;
    self.animatedImageView.animationRepeatCount = 0;
    [self.animatedImageView startAnimating];
    [self.button setTitle:self.titleText forState:UIControlStateNormal];
}

- (IBAction)goTo:(id)sender {
    if ([self.imageFile isEqualToString:@"1_"]){
        UIPageViewController *pageViewController = (UIPageViewController*)self.parentViewController;
        TutorialViewController *tVC = (TutorialViewController*)pageViewController.parentViewController;
        [tVC navigateForward];
    }else if([self.imageFile isEqualToString:@"2_"]){
        UIPageViewController *pageViewController = (UIPageViewController*)self.parentViewController;
        TutorialViewController *tVC = (TutorialViewController*)pageViewController.parentViewController;
        [tVC navigateForward];
        
    }else{
        [self addMainViewController];
    }
}


-(void)addMainViewController
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
