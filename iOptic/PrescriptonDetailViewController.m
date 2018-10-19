//
//  PrescriptonDetailViewController.m
//  iOptic
//
//  Created by Santhosh on 27/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "PrescriptonDetailViewController.h"
#import "CreatePrescriptionViewController.h"
#import "PrescriptionDetailsViewTableViewCell.h"
#import "XTableViewCell.h"
#import "YTableViewCell.h"
#import "NotesViewTableViewCell.h"
#import "QRCodeTableViewCelTableViewCell.h"
#import "UIImage+MDQRCode.h"
@import Firebase;

@interface PrescriptonDetailViewController ()
@property(nonatomic) NSUInteger numberOfSections;

@end

@implementation PrescriptonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PrescriptionDetailsViewTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PrescriptionDetailsViewTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NotesViewTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NotesViewTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QRCodeTableViewCelTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QRCodeTableViewCelTableViewCell"];


    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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


- (IBAction)closeBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)delete:(id)sender {
    __weak typeof (self)weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"iOptic" message:@"Do you want to delete the prescription?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteThePrescription];
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:^{
        
    }];

}

-(void)deleteThePrescription{
    [FIRAnalytics logEventWithName:@"BTN_CLICK_DELETE_PRESP"
                        parameters:@{
                                     kFIRParameterItemID:@"BTN_CLICK_DELETE_PRESP",
                                     kFIRParameterItemName:@"Delete Prescription",
                                     kFIRParameterContentType:@"text"
                                     }];

    NSMutableArray *prescriptions = [[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:prescriptions];
    if (prescriptions != nil)
    {
        for (NSDictionary *prescription in tempArray){
            if ([prescription valueForKey:self.name]){
                [tempArray removeObject:prescription];
                break;
            }
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prescriptions"];
        [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:@"prescriptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)edit:(id)sender {
    //
    __weak typeof (self)weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Edit" message:[NSString stringWithFormat:@"Do you want to edit %@ prescription?",self.name] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showCreatePrescription];
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:^{
        
    }];
    
   

}

-(void)showCreatePrescription
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    [FIRAnalytics logEventWithName:@"BTN_CLICK_EDIT_PRESP"
                        parameters:@{
                                     kFIRParameterItemID:@"BTN_CLICK_EDIT_PRESP",
                                     kFIRParameterItemName:@"Edit Prescription",
                                     kFIRParameterContentType:@"text"
                                     }];

    
    CreatePrescriptionViewController *viewcontroller =[storyboard instantiateViewControllerWithIdentifier:@"CreatePrescriptionViewController"];
    viewcontroller.selectedPrescriptionName = self.name;
    viewcontroller.selectedPrescriptionDetails = self.currentPrescriptionDict;
    
    [navigationController setViewControllers:@[viewcontroller]];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CreatePrescriptionViewController *detailVC = segue.destinationViewController;
    detailVC.selectedPrescriptionName = self.name;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"]&&[self.currentPrescriptionDict valueForKey:@"prescriptionGlasses"]&&[[self.currentPrescriptionDict valueForKey:@"prescriptionInfo"] valueForKey:@"notes"]){
        self.numberOfSections = 4+1;
        return  4+1;
    }else if([self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"]&&[self.currentPrescriptionDict valueForKey:@"prescriptionGlasses"]) {
        self.numberOfSections = 3+1;

        return 3+1;
    }else if (([self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"]||[self.currentPrescriptionDict valueForKey:@"prescriptionGlasses"])){
        if ([[self.currentPrescriptionDict valueForKey:@"prescriptionInfo"] valueForKey:@"notes"]){
            self.numberOfSections = 3+1;
            return 3+1;
        }else{
            self.numberOfSections = 2+1;
            return 2+1;
        }
    }else{
        self.numberOfSections = 2+1;
        return 2+1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        return  300.0f;
    }else if((indexPath.section == 1)&&([self.currentPrescriptionDict valueForKey:@"prescriptionGlasses"])){
        return 918.0f;
    }else if((indexPath.section == 1)&&([self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"])){
        return 640.0f;
    }else if((indexPath.section == 2)&&([self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"])&&[self.currentPrescriptionDict valueForKey:@"prescriptionGlasses"]){
        return 718.0f;
    }else if((indexPath.section == 2)&&([[self.currentPrescriptionDict valueForKey:@"prescriptionInfo"] valueForKey:@"notes"])){
        return 141.0f;
    }else{
        return 350.0f;

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        PrescriptionDetailsViewTableViewCell *tableViewCell = (PrescriptionDetailsViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"PrescriptionDetailsViewTableViewCell" forIndexPath:indexPath];
        if (self.currentPrescriptionDict){
            tableViewCell.nameHeaderLbl.text = [[self.currentPrescriptionDict valueForKey:@"prescriptionInfo"] valueForKey:@"name"];
            tableViewCell.nameLbl.text = [[self.currentPrescriptionDict valueForKey:@"prescriptionInfo"] valueForKey:@"name"];
            tableViewCell.doctorNameLbl.text = [[self.currentPrescriptionDict valueForKey:@"prescriptionInfo"] valueForKey:@"doctorName"];
            tableViewCell.dateLbl.text = [[self.currentPrescriptionDict valueForKey:@"prescriptionInfo"] valueForKey:@"date"];
        }
        return tableViewCell;
    }else if ((indexPath.section == 1)&& ([self.currentPrescriptionDict valueForKey:@"prescriptionGlasses"])){
        XTableViewCell *tableViewCell = (XTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"XTableViewCell" forIndexPath:indexPath];
        if ([self.currentPrescriptionDict valueForKey:@"prescriptionGlasses"]){
            [tableViewCell updateCellDetails:[self.currentPrescriptionDict valueForKey:@"prescriptionGlasses"]];
        }
        return tableViewCell;
        
    }else if ((indexPath.section == 1) &&([self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"])){
        YTableViewCell *tableViewCell = (YTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"YTableViewCell" forIndexPath:indexPath];
        if ([self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"]){
            [tableViewCell updateDetails:[self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"]];
        }
        return tableViewCell;
    }
    else if ((indexPath.section == 2)&&((([self.currentPrescriptionDict valueForKey:@"prescriptionGlasses"]&&[self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"])) ||
        ((indexPath.section == 1 &&[self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"]))))
        {
        YTableViewCell *tableViewCell = (YTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"YTableViewCell" forIndexPath:indexPath];
        if ([self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"]){
            [tableViewCell updateDetails:[self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"]];
        }
        return tableViewCell;
    }
     else if ((indexPath.section == 3&&[self.currentPrescriptionDict valueForKey:@"prescriptionGlasses"]&&
        [self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"]&&[[self.currentPrescriptionDict valueForKey:@"prescriptionInfo"] valueForKey:@"notes"]) || (indexPath.section == 2 &&([self.currentPrescriptionDict valueForKey:@"prescriptionGlasses"]||[self.currentPrescriptionDict valueForKey:@"prescriptionContactLens"])&&[[self.currentPrescriptionDict valueForKey:@"prescriptionInfo"] valueForKey:@"notes"])){
        NotesViewTableViewCell *tableViewCell = (NotesViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NotesViewTableViewCell" forIndexPath:indexPath];
        if ([[self.currentPrescriptionDict valueForKey:@"prescriptionInfo"] valueForKey:@"notes"]){
            [tableViewCell.notesDescLbl setEditable:NO];
            
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic"
                                               size:17.0f];
            [tableViewCell.notesLabel setFont:font];
            [tableViewCell.notesDescLbl setFont:font];
            [tableViewCell.notesDescLbl setText:[[self.currentPrescriptionDict valueForKey:@"prescriptionInfo"] valueForKey:@"notes"]];
        }
        return tableViewCell;
        
     }else {
         QRCodeTableViewCelTableViewCell *tableViewCell = (QRCodeTableViewCelTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"QRCodeTableViewCelTableViewCell" forIndexPath:indexPath];
         NSData *nsdata = [self.currentPrescriptionJSON
                           dataUsingEncoding:NSUTF8StringEncoding];
         // Get NSString from NSData object in Base64
         NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
         
         
         [tableViewCell updateQR:base64Encoded];
         return tableViewCell;

     }
    return  nil;
}







@end
