//
//  TutorialViewController.m
//  iOptic
//
//  Created by Santhosh on 19/08/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "TutorialViewController.h"
#import "TutorialContentViewController.h"

@interface TutorialViewController ()
@property(strong) NSArray *viewControllers;
@property(assign) NSUInteger currentPageIndex;


@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageImages = @[@"1_", @"2_", @"3_"];
    _pageTitles = @[@"CONTINUE", @"CONTINUE", @"LETS GET STARTED"];
    _pageDescriptions = @[@"Meet iOptic, an ingenious app to digitally save your Eye Prescriptions.", @"Saving an eye prescription, digitally has never been so easy.", @"Like Never Before, Discover an effortless way to share prescription with QR code."];

    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    TutorialContentViewController *startingViewController = [self viewControllerAtIndex:0];
//    TutorialContentViewController *secondVC = [self viewControllerAtIndex:1];
//    TutorialContentViewController *thirdVC = [self viewControllerAtIndex:2];

    self.viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:@[startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // Change the size of page view controller
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
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

- (TutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TutorialContentViewController *pageContentViewController = [storyboard instantiateViewControllerWithIdentifier:@"TutorialContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.headerText = self.pageDescriptions[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
   // NSUInteger index = ((TutorialContentViewController*) viewController).pageIndex;
    
    
    NSUInteger currentIndex = [self.viewControllers indexOfObject:viewController];
    --currentIndex;
    currentIndex = currentIndex % (self.viewControllers.count);
    _currentPageIndex=currentIndex;
    
    if ((currentIndex == 0) || (currentIndex == NSNotFound)) {
        return nil;
    }
    
    //index--;
    return [self viewControllerAtIndex:currentIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutorialContentViewController*) viewController).pageIndex;
//    NSUInteger currentIndex = [self.viewControllers indexOfObject:viewController];
//
//    ++currentIndex;
//    currentIndex = currentIndex % (self.viewControllers.count);
//    _currentPageIndex=currentIndex;
//    if (currentIndex == NSNotFound) {
//        return nil;
   // }
    index += 1;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)navigateForward{
    NSUInteger currentIndex = self.currentPageIndex;
    
    ++currentIndex;
    currentIndex = currentIndex % (self.viewControllers.count);
    
    self.currentPageIndex=currentIndex;
    
    [self.pageViewController setViewControllers:@[[self.viewControllers objectAtIndex:currentIndex]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES completion:nil];
}

@end
