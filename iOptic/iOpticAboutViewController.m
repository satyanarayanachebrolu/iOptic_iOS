//
//  iOpticAboutViewController.m
//  iOptic
//
//  Created by Satyanarayana Chebrolu on 9/9/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "iOpticAboutViewController.h"
#import "AppDelegate.h"
#import "iOpticTextViewController.h"

@interface iOpticAboutViewController ()
@property(nonatomic, weak) IBOutlet UILabel *versionNumberLabel;
@end

@implementation iOpticAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *versionNo = [[NSBundle mainBundle] infoDictionary] [@"CFBundleShortVersionString"];
    self.versionNumberLabel.text = [NSString stringWithFormat:@"iOptic %@",versionNo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) closeTapped:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    [appDelegate goToMainViewController];
}

-(IBAction)termsAndConditionsTapped:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    iOpticTextViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"iOpticTextViewController"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TermsAndConditions" ofType:@"rtf"];
    vc.modalPresentationStyle = UIModalPresentationPageSheet;
    [self showViewController:vc sender:self];
    NSString *fPath = [NSString stringWithFormat:@"file://%@", filePath];
    NSURL *fileURL = [NSURL URLWithString:fPath];
    
    NSError *error;
    
    NSAttributedString *attributedStringWithRtf = [[NSAttributedString alloc]   initWithURL:fileURL options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType}  documentAttributes:nil error:&error];

    vc.textView.attributedText = attributedStringWithRtf;

}


-(IBAction)privacyPolicyTapped:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    iOpticTextViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"iOpticTextViewController"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PrivacyPolicy" ofType:@"rtf"];
    vc.modalPresentationStyle = UIModalPresentationPageSheet;
    [self showViewController:vc sender:self];
    NSString *fPath = [NSString stringWithFormat:@"file://%@", filePath];
    NSURL *fileURL = [NSURL URLWithString:fPath];
    
    NSError *error;
    
    NSAttributedString *attributedStringWithRtf = [[NSAttributedString alloc]   initWithURL:fileURL options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType}  documentAttributes:nil error:&error];
    
    vc.textView.attributedText = attributedStringWithRtf;

}



@end
