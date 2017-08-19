
#import "iOpticTutorialViewController.h"
#import "iOpticTutorialContentViewController.h"

@interface iOpticTutorialViewController ()
@property(strong) NSArray *viewControllers;
@property(assign) NSUInteger currentPageIndex;


@end

@implementation iOpticTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageImages = @[@"1", @"2", @"3"];
    _pageTitles = @[@"CONTINUE", @"CONTINUE", @"LETS GET STARTED"];
    _pageDescriptions = @[@"Meet iOptic, an ingenious app to digitally save your Eye Prescriptions.", @"Saving an eye prescription, digitally has never been so easy.", @"Like Never Before, Discover an effortless way to share prescription with QR code."];

    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    iOpticTutorialContentViewController *startingViewController = [self viewControllerAtIndex:0];
    [self.pageViewController setViewControllers:@[startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (iOpticTutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    iOpticTutorialContentViewController *pageContentViewController = [storyboard instantiateViewControllerWithIdentifier:@"iOpticTutorialContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.headerText = self.pageDescriptions[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((iOpticTutorialContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((iOpticTutorialContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound)
    {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count])
    {
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
    
    self.currentPageIndex = currentIndex;
    
    [self.pageViewController setViewControllers:@[[self.viewControllers objectAtIndex:currentIndex]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES completion:nil];
}

@end
