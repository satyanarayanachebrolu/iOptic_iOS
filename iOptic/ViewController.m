//
//  ViewController.m
//  iOptic
//
//  Created by Satyanarayana Chebrolu on 5/23/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "ViewController.h"
#import "PrescriptionManager.h"
#import "PrescriptionTableViewCell.h"
#import "PrescriptonDetailViewController.h"
#import "ScanViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"



@interface ViewController ()
@property(nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) IBOutlet UILabel *staticLabel;
@property(nonatomic) NSArray <Prescription*> *prescritionsList;
@property(nonatomic,strong) NSString *selectedPrescriptionName;
@property(nonatomic,strong) NSDictionary *currentPrescription;
@property(nonatomic,strong) NSString *currentJSON;


@property (weak, nonatomic) IBOutlet UILabel *welcomeMessageLbl;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.prescritionsList = [[PrescriptionManager shareInstance] prescriptionsList];

    if(self.prescritionsList.count == 0)
    {
        self.staticLabel.hidden = NO;
        self.welcomeMessageLbl.hidden = NO;
//        self.tableView.hidden = YES;
        [self.tableView reloadData];
    }
    else
    {
        self.staticLabel.hidden = YES;
        self.welcomeMessageLbl.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PrescriptonDetailViewController *detailVC = segue.destinationViewController;
    
    NSMutableArray *prescriptionsSaved = [[[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"] mutableCopy];
    __block NSMutableDictionary * prescription;
    __block NSString *json;
    [prescriptionsSaved enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop)
     {
         if ([item valueForKey:self.selectedPrescriptionName]){
             prescription = [item valueForKey:self.selectedPrescriptionName];
             NSError *error = nil;
             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:prescription                                                                options:NSJSONWritingPrettyPrinted error:&error];
             json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
             *stop = YES;
         }
     }];
    
    if (prescription == nil) {
        detailVC.currentPrescriptionDict = self.currentPrescription;
        detailVC.currentPrescriptionJSON = self.currentJSON;
        detailVC.name = [[self.currentPrescription valueForKey:@"prescriptionInfo"] valueForKey:@"name"];
    }else{
        detailVC.currentPrescriptionJSON = json;
        detailVC.currentPrescriptionDict = prescription;
        detailVC.name = [[prescription valueForKey:@"prescriptionInfo"] valueForKey:@"name"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.prescritionsList.count == 0){
        return self.prescritionsList.count +2;
    }else{
        return self.prescritionsList.count +1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row != self.prescritionsList.count) && (self.prescritionsList.count)) {
        UITableViewCell *cell = (PrescriptionTableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:@"prescriptioncell"];
        cell.layer.cornerRadius = 4;
        
        UILabel *namelabel = (UILabel*)[cell viewWithTag:1];
        namelabel.text = self.prescritionsList[indexPath.row].name;
        
        UILabel *doctorlabel = (UILabel*)[cell viewWithTag:2];
        doctorlabel.text = self.prescritionsList[indexPath.row].doctorName;
        
        UILabel *datelabel = (UILabel*)[cell viewWithTag:3];
        datelabel.text = self.prescritionsList[indexPath.row].date;
        return cell;
    }
    else {
        if (indexPath.row == 0){
            UITableViewCell *cell = (UITableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:@"EmptyTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }else{
            UITableViewCell *cell = (UITableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:@"addPrescription"];
            return cell;
        }
    }
//
//    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
//    imageView.image = [UIImage imageNamed:self.menuItemsList[indexPath.row].iconName];
//    cell.backgroundColor = [UIColor clearColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.row == self.prescritionsList.count) && (self.prescritionsList.count)) {
        [self addPrescriptionAction:self];
    } else if(self.prescritionsList.count == 0){
        return;
    }else{
        Prescription * p = [self.prescritionsList objectAtIndex:indexPath.row];
        self.selectedPrescriptionName = p.name;
        [self performSegueWithIdentifier:@"showPrescprion" sender:self];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row != self.prescritionsList.count){
        
    }else{
        if (indexPath.row == 0){
            return 350.0f;
        }
    }
    return 140.0;
}

-(IBAction)addPrescriptionAction:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    [navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"CreatePrescriptionViewController"]]];

    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)CameraBtnPressed:(id)sender {
    NSLog(@"camera button pressed");
    
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }

    
    
   /* if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            // Will get here on both iOS 7 & 8 even though camera permissions weren't required
            // until iOS 8. So for iOS 7 permission will always be granted.
            if (granted) {
                // Permission has been granted. Use dispatch_async for any UI updating
                // code because this block may be executed in a thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ScanViewController *scanViewController = [storyboard instantiateViewControllerWithIdentifier:@"ScanViewController"];
                    [self.navigationController pushViewController:scanViewController animated:YES] ;
                });
            } else {
                // Permission has been denied.
            }
        }];
    } else {
        // We are on iOS <= 6. Just do what we need to do.
        //[self doStuff];
    }*/
    

}
#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [reader stopScanning];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSData *nsdataFromBase64String = [[NSData alloc]
                                          initWithBase64EncodedString:result options:0];
        if (nsdataFromBase64String == nil){
            [self showErrorMessage];
            return;
        }
        
        // Decoded NSString from the NSData
        NSString *base64Decoded = [[NSString alloc]
                                   initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
        NSLog(@"base64Decoded:%@",base64Decoded);
        NSError *jsonError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:nsdataFromBase64String
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        self.selectedPrescriptionName = [[json valueForKey:@"prescriptionInfo"] valueForKey:@"name"];
        self.currentPrescription = json;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json                                                               options:NSJSONWritingPrettyPrinted error:&jsonError];
        self.currentJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (jsonError == nil){
            [self performSegueWithIdentifier:@"showPrescprion" sender:self];
        }else{
         
            

        }
       
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)showErrorMessage
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@""
                                                                    message:@"There is some issue in reading the QR Code"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alertC addAction:defaultAction];
    [self presentViewController:alertC animated:NO completion:nil];
}

@end
