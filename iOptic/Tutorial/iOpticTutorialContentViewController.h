
#import <UIKit/UIKit.h>

@interface iOpticTutorialContentViewController : UIViewController
@property (assign) NSUInteger pageIndex;
@property (strong) NSString *titleText;
@property (strong) NSString *headerText;
@property (strong) NSString *imageFile;

@property (weak, nonatomic) IBOutlet UIImageView *animatedImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
