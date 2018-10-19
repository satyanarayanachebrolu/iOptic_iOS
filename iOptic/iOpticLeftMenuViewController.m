//
//  iOpticLeftMenuViewController.m
//  iOptic
//
//  Created by Satyanarayana Chebrolu on 5/24/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "iOpticLeftMenuViewController.h"
#import "MenuItem.h"
#import "UIViewController+LGSideMenuController.h"
#import "AppDelegate.h"
#import "iOpticAboutViewController.h"

@import FBSDKCoreKit;
@import FBSDKLoginKit;
@import Firebase;


@import Firebase;

@interface iOpticLeftMenuViewController ()
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, weak) IBOutlet UILabel *displayNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *emailIdLabel;
@property(nonatomic, weak) IBOutlet UIImageView *profileImageView;

@property(nonatomic, strong) NSMutableArray<MenuItem*> *menuItemsList;
@end

@implementation iOpticLeftMenuViewController

- (void)reloadMenu
{
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
        self.emailIdLabel.text = user.email;
        self.displayNameLabel.text = user.displayName;
        
        NSURL *profileDPURL = user.photoURL;
        if(profileDPURL)
        {
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [indicator startAnimating];
            [indicator setCenter:self.profileImageView.center];
            [self.view addSubview:indicator];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                UIImage *image = [UIImage imageWithCIImage:[CIImage imageWithContentsOfURL:profileDPURL]];
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [indicator removeFromSuperview];
                                   self.profileImageView.image = image;
                               });
            });

        }
    }
    else
    {
        self.emailIdLabel.text = @"";
        self.displayNameLabel.text = @"Welcome";
        self.profileImageView.image = [UIImage imageNamed:@"default_profile_icon"];
    }

    self.menuItemsList = [NSMutableArray new];
    MenuItem *menuItem = [MenuItem new];
    menuItem.iconName = @"home_icon";
    menuItem.title = @"home";
    menuItem.identifier = @"iOpticHomeViewController";
    [self.menuItemsList addObject:menuItem];
    
    menuItem = [MenuItem new];
    menuItem.iconName = @"about_icon";
    menuItem.title = @"about";
    menuItem.identifier = @"iOpticAboutViewController";
    [self.menuItemsList addObject:menuItem];
    
    if(user && emailVerified)
    {
        menuItem = [MenuItem new];
        menuItem.iconName = @"logout_icon";
        menuItem.title = @"logout";
        menuItem.identifier = @"LogoutViewController";
        [self.menuItemsList addObject:menuItem];
    }
    else
    {
        menuItem = [MenuItem new];
        menuItem.iconName = @"loginicon";
        menuItem.title = @"login";
        menuItem.identifier = @"LoginViewController";
        [self.menuItemsList addObject:menuItem];
    }
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadMenu];
    /*menuItem = [MenuItem new];
     menuItem.iconName = @"help_icon";
     menuItem.title = @"help & faq's";
     menuItem.identifier = @"iOpticHelpAndFaqsViewController";
     [self.menuItemsList addObject:menuItem];
     
     menuItem = [MenuItem new];
     menuItem.iconName = @"settings_icon";
     menuItem.title = @"settings";
     menuItem.identifier = @"iOpticSettingsViewController";
     [self.menuItemsList addObject:menuItem];*/

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItemsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LeftMenuCell"];
    
    UILabel *label = (UILabel*)[cell viewWithTag:2];
    label.text = self.menuItemsList[indexPath.row].title;
    
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
    imageView.image = [UIImage imageNamed:self.menuItemsList[indexPath.row].iconName];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LGSideMenuController *sideMenuController = self.sideMenuController;
    [sideMenuController hideLeftViewAnimated];
    
    NSString *identifier = self.menuItemsList[indexPath.row].identifier;
    
    if([identifier isEqualToString:@"iOpticHomeViewController"])
    {
        [FIRAnalytics logEventWithName:@"NAV_BTN_CLICK_HOME"
                            parameters:@{
                                         kFIRParameterItemID:@"NAV_BTN_CLICK_HOME",
                                         kFIRParameterItemName:@"NAV MENU HOME",
                                         kFIRParameterContentType:@"text"
                                         }];

    }
    else if([identifier isEqualToString:@"iOpticAboutViewController"])
    {
        [FIRAnalytics logEventWithName:@"NAV_BTN_CLICK_ABOUT"
                            parameters:@{
                                         kFIRParameterItemID:@"NAV_BTN_CLICK_ABOUT",
                                         kFIRParameterItemName:@"NAV MENU ABOUT",
                                         kFIRParameterContentType:@"text"
                                         }];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        iOpticAboutViewController *aboutVC = [storyboard instantiateViewControllerWithIdentifier:@"iOpticAboutViewController"];

        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        window.rootViewController = aboutVC;
    }
    else if([identifier isEqualToString:@"LoginViewController"])
    {
        [FIRAnalytics logEventWithName:@"NAV_BTN_CLICK_LOGIN"
                            parameters:@{
                                         kFIRParameterItemID:@"NAV_BTN_CLICK_LOGIN",
                                         kFIRParameterItemName:@"NAV MENU LOGIN",
                                         kFIRParameterContentType:@"text"
                                         }];

        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate showLoginScreen];
    }
    else if([identifier isEqualToString:@"LogoutViewController"])
    {
        [FIRAnalytics logEventWithName:@"NAV_BTN_CLICK_LOGOUT"
                            parameters:@{
                                         kFIRParameterItemID:@"NAV_BTN_CLICK_LOGOUT",
                                         kFIRParameterItemName:@"NAV MENU LOGOUT",
                                         kFIRParameterContentType:@"text"
                                         }];

        [[FIRAuth auth] signOut:nil];
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSString *loginType = [userdefaults objectForKey:@"loginType"];
        if([loginType isEqualToString:@"google"])
        {
            [[GIDSignIn sharedInstance] signOut];
        }
        else if([loginType isEqualToString:@"fb"])
        {
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager logOut];
        }

        [self reloadMenu];
    }
}

@end
