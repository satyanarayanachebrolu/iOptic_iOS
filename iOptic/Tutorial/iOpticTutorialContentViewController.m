
#import "iOpticTutorialContentViewController.h"
#import "UIImage+animatedGIF.h"

@interface iOpticTutorialContentViewController ()

@end

@implementation iOpticTutorialContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.headerLbl.text = self.headerText;
    [self.button setTitle:self.titleText forState:UIControlStateNormal];
    
    //NSURL *url = [[NSBundle mainBundle] URLForResource:self.imageFile withExtension:@"gif"];
   // self.animatedImageView.image = [UIImage animatedImageWithAnimatedGIFURL:url];

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
    /*AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
    if ([self.imageFile isEqualToString:@"1_"]){
        self.animatedImageView.animationImages = appDelegate.firstGIF;

    }else if([self.imageFile isEqualToString:@"2_"]){
        self.animatedImageView.animationImages = appDelegate.secondGIF;
    }else{
        self.animatedImageView.animationImages = appDelegate.thirdGIF;
    }
   
    
    self.headerLbl.text = self.headerText;
    [self.button setTitle:self.titleText forState:UIControlStateNormal];*/
}

- (IBAction)goTo:(id)sender {
    /*if ([self.imageFile isEqualToString:@"1_"]){
        UIPageViewController *pageViewController = (UIPageViewController*)self.parentViewController;
        TutorialViewController *tVC = (TutorialViewController*)pageViewController.parentViewController;
        [tVC navigateForward];
    }else if([self.imageFile isEqualToString:@"2_"]){
        UIPageViewController *pageViewController = (UIPageViewController*)self.parentViewController;
        TutorialViewController *tVC = (TutorialViewController*)pageViewController.parentViewController;
        [tVC navigateForward];
        
    }else{
        [self addMainViewController];
    }*/
}



@end
