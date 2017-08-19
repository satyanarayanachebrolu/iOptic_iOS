
#import <UIKit/UIKit.h>

@interface iOpticTutorialViewController : UIViewController<UIPageViewControllerDataSource>


@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageDescriptions;
@property (strong, nonatomic) NSArray *pageImages;
- (void)navigateForward;
@end
