//
//  CreatePrescriptionViewController.m
//  Test
//
//  Created by Satyanarayana Chebrolu on 8/25/16.
//  Copyright © 2016 Satyanarayana Chebrolu. All rights reserved.
//

#import "CreatePrescriptionViewController.h"
#import "PickerViewController.h"
#import "Prescription.h"
#import "PrescriptionManager.h"
#import "LensCategoryTableViewCell.h"
#import "ContactLensPrescriptionTableViewCell.h"
#import "NotesTableViewCell.h"
#import "PrescriptionTypeTableViewCell.h"
#import "LensPowerTableViewCell.h"
#import "LensAxisTableViewCell.h"
#import "PrismValuesTableViewCell.h"
#import "PupillaryTableViewCell.h"
#import "LensTypeTableViewCell.h"
#import "PersonDetailsTableViewCell.h"
#import "DatePickerViewController.h"
#import "iOptic-Swift.h"
#import "UIView+Toast.h"
#import "UIViewController+Alerts.h"

@import Firebase;


#define NAME_TAG 123456

#define POWER_RIGHT 12
#define POWER_LEFT  15
#define BC_RIGHT  13
#define BC_LEFT  16
#define DIA_RIGHT  14
#define DIA_LEFT  17
#define ADD_RIGHT  18
#define ADD_LEFT  21
#define AXIS_LEFT  25
#define AXIS_RIGHT  19
#define PRESCRIPTION_TYPE  55
#define SPHERE_RIGHT  555
#define SPHERE_LEFT  55555
#define CYLINDER_RIGHT  5555
#define CYLINDER_LEFT  555555
#define AXIS_REGULAR_RIGHT  22
#define AXIS_REGULAR_LEFT  22222
#define ADD_REGULAR_RIGHT  222
#define ADD_REGULAR_LEFT  2222222
#define PRISM_RIGHT 3
#define PRISM_LEFT 333


@interface CreatePrescriptionViewController ()<PickerViewControllerDelegate,PrismValuesTableViewCellDelegate,PupillaryTableViewCellDelegate,ContactLensPrescriptionTableViewCellDelegate,PrescriptionTypeTableViewCellDelegate,LensPowerTableViewCellDelegate,LensTypeTableViewCellDelegate,LensAxisTableViewCellDelegate,NotesTableViewCellDelegate,UITextFieldDelegate,UIScrollViewDelegate,DatePickerViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic) PickerViewController *pickerViewController;
@property(nonatomic) DatePickerViewController *datePickerViewController;

@property(nonatomic) NSArray *heightsList;
@property(nonatomic) NSIndexPath *tappedIndexPath;
@property(nonatomic) NSInteger tappedTag;
@property(nonatomic) Prescription *prescription;
@property(nonatomic) BOOL isContactLensCategorySelected;
@property(nonatomic) BOOL isRegularLensCategorySelected;
@property(nonatomic) NSUInteger numberOfSections;
@property(nonatomic) BOOL isPrismSelected;
@property(nonatomic) BOOL isSinglePDSelected;
@property(nonatomic) BOOL isDualPDSelected;
@property(nonatomic) BOOL isRegularContactLensSelected;
@property(nonatomic) BOOL isBifocalContactLensSelected;
@property(nonatomic) BOOL isAstigmatismSelected;
@property(nonatomic) BOOL isFirstTime;
@property(nonatomic) NSInteger computedIndexPathSection;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *doctorName;
@property(nonatomic) NSString *date;
@property(nonatomic) BOOL isDistanceLensSelected;
@property(nonatomic) NSString *oldName;
@property(nonatomic) BOOL isPDIgnored;


// values to preserve
@property(nonatomic) PrismSelctionType prismSelectionType;
@property(nonatomic) NSMutableDictionary *neededConfiguration;


@property(nonatomic) NSMutableDictionary *personalDetails;
@property(nonatomic) NSMutableDictionary *pdDetails;
@property(nonatomic) NSMutableDictionary *regularPrismDetails;


@property(nonatomic) NSMutableDictionary *contactLensDetails;
@property(nonatomic) NSMutableDictionary *regularLensDetails;

@property (nonatomic) NSMutableDictionary *editableDetails;


@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *nameTextFiled;


@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *doctorTextField;




//@property (weak, nonatomic) IBOutlet UITextField *nameOfThePrescriptionTextField;

@end


@implementation CreatePrescriptionViewController


//-(void)dismissKeyboard
//{
//    self.editing = NO; //[sel resignFirstResponder];
//}

-(void)viewDidLoad
{
//    self.heightsList = @[@173, @97, @80, @120, @120, @250, @265, @130,@130,@130,@130,@130,@130];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];
    
    self.heightsList = @[@173, @120, @120, @120, @120, @250, @265, @130,@130,@130,@130,@130,@130];

    self.prescription = [Prescription new];
    self.numberOfSections = 3;
    self.prismSelectionType = NONE;
    self.isFirstTime = YES;
    

    
    // Register Nibs
    [self registerTableViewCells];
    
    
    if (self.selectedPrescriptionName.length > 0){
        NSMutableArray *prescriptions = [[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"];

        if (prescriptions != nil && prescriptions.count > 0){
            __block NSUInteger indexOfExistingObj = 0;
            [prescriptions enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop)
             {
                 if ([item valueForKey:self.selectedPrescriptionName]){
                     self.editableDetails = [[item valueForKey:self.selectedPrescriptionName] mutableCopy];
                     indexOfExistingObj = idx;
                     *stop = YES;
                 }
             }];
        }
            if (self.editableDetails == nil){
                self.editableDetails = self.selectedPrescriptionDetails;
            }
            NSMutableDictionary *personalDetails = [self.editableDetails valueForKey:@"prescriptionInfo"];
            self.oldName = [personalDetails valueForKey:@"name"];
            self.personalDetails = [[self.editableDetails valueForKey:@"prescriptionInfo"] mutableCopy];
            self.pdDetails = [[[self.editableDetails valueForKey:@"prescriptionGlasses"] valueForKey:@"pd"] mutableCopy];
        
            if(!self.pdDetails)
                self.pdDetails = [[NSMutableDictionary alloc] init];

            self.prescription.name = [personalDetails valueForKey:@"name"];
            self.doctorName = [personalDetails valueForKey:@"doctorName"];
            self.neededConfiguration = [self.editableDetails mutableCopy];
            if ([self.editableDetails valueForKey:@"prescriptionContactLens"]){
                NSMutableDictionary *contactLensDetails = [NSMutableDictionary dictionaryWithDictionary:[self.editableDetails valueForKey:@"prescriptionContactLens"]];
                self.contactLensDetails =  contactLensDetails;//[contactLensDetails mutableCopy];
                [self contactLensTapped:nil];
                self.isContactLensCategorySelected = YES;
                [self.neededConfiguration setValue:[NSNumber numberWithBool:true] forKey:@"contactLens"];
                if ([[[self.editableDetails valueForKey:@"prescriptionContactLens"] valueForKey:@"contactType"] isEqualToString:@"Regular Contacts"]){
                    self.isRegularContactLensSelected = YES;
                }else if([[[self.editableDetails valueForKey:@"prescriptionContactLens"] valueForKey:@"contactType"] isEqualToString: @"Bifocal Contacts"]){
                    self.isBifocalContactLensSelected  = YES;
                }else if ([[[self.editableDetails valueForKey:@"prescriptionContactLens"] valueForKey:@"contactType"] isEqualToString: @"Astigmatism"]){
                    self.isAstigmatismSelected = YES;
                }
            }
            if ([self.editableDetails valueForKey:@"prescriptionGlasses"]){
                NSMutableDictionary *regularLensDetails = [NSMutableDictionary dictionaryWithDictionary:[self.editableDetails valueForKey:@"prescriptionGlasses"]];
                self.regularLensDetails =  regularLensDetails;//[contactLensDetails mutableCopy];
                [self regularLensCategoryTapped:nil];
                self.isRegularContactLensSelected = YES;
                if ([[self.regularLensDetails valueForKey:@"prismValues"] count] > 0){
                    self.prismSelectionType = YES_SELECTED; // Table loding FIX ME
                    self.isPrismSelected = YES;
                    
                }else if([[self.regularLensDetails valueForKey:@"prismValues"] count] == 0){
                    self.prismSelectionType = NO_SELECTED;
                }
                if ([self.pdDetails valueForKey:@"singlePd"]){
                    self.isSinglePDSelected = YES;
                    [self.regularLensDetails setValue:[NSNumber numberWithBool:false] forKey:@"isDualPd"];
                }else if([self.pdDetails valueForKey:@"dualPd"]){
                    self.isDualPDSelected = YES;
                    [self.regularLensDetails setValue:[NSNumber numberWithBool:true] forKey:@"isDualPd"];
                }
            }
            else
            {
                NSLog(@"No Regular lens yet");
            }
    }else{
        self.personalDetails = [NSMutableDictionary dictionaryWithCapacity:3];
        self.pdDetails = [[NSMutableDictionary alloc] init];
        self.contactLensDetails = [[NSMutableDictionary alloc] init];
        self.neededConfiguration = [[NSMutableDictionary alloc] init];
        self.regularLensDetails = [[NSMutableDictionary alloc] init];
        [self.neededConfiguration setObject:self.personalDetails forKey:@"prescriptionInfo"];
    }
    
    
//    [self contactLensTapped:nil];
//   self.isRegularContactLensSelected = YES;
    //[self regularLensCategoryTapped:nil];

}

-(void)registerTableViewCells
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactLensPrescriptionTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ContactLensPrescriptionTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NotesTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NotesTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PrescriptionTypeTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PrescriptionTypeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LensPowerTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LensPowerTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LensAxisTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LensAxisTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PrismValuesTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PrismValuesTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PupillaryTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PupillaryTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LensTypeTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LensTypeTableViewCell"];
}


-(void)dealloc
{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.editing = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.computedIndexPathSection = indexPath.section;

    if(indexPath.section == 0)
    {
        return 178;
    }else if(self.computedIndexPathSection == 1){
        return 102;
    }else if(indexPath.section == 2){
        CGFloat h = 0.0f;
        if (self.isContactLensCategorySelected){
             h =145.0f;
            if (self.isRegularContactLensSelected){
                h = 285.0f;
            }else if(self.isAstigmatismSelected || self.isBifocalContactLensSelected){
                h = 435.0f;
            }
        }else{
            h = 131.0f;//95.0f
        }
        return h;
    }else if(indexPath.section == 3){
        if (!self.isRegularLensCategorySelected){
            return 120;
        }else if (self.isRegularLensCategorySelected && self.isContactLensCategorySelected){
            return 95.0f;
        }else{
            return 140.0f;//135
        }
    }else if(indexPath.section == 4){
        if (!self.isRegularLensCategorySelected){
            return 140.0f; // 4 increased//135
        }else if(self.isRegularLensCategorySelected && self.isContactLensCategorySelected){
            return 140.0f;//135
        }else{
            return 140.0f;//135
        }
    }else if(indexPath.section == 5){
        if (self.isRegularLensCategorySelected && self.isContactLensCategorySelected){
            return 140.0f;
        }else{
            if (self.isPrismSelected){
                return 227;
            }else{
                return 80;
            }
        }
    }else if(indexPath.section == 6){
        if (self.isRegularLensCategorySelected && self.isContactLensCategorySelected){
            if (self.isPrismSelected){
                return 227;
            }else{
                return 80;
            }
        }
        if (!self.isSinglePDSelected && !self.isDualPDSelected){
            return 73;
        }else if(self.isSinglePDSelected){
            return 140;
        }else{
            return 195;
        }
    }else if(indexPath.section == 7){
        if (self.isRegularLensCategorySelected && self.isContactLensCategorySelected){
            if (!self.isSinglePDSelected && !self.isDualPDSelected){
                return 73;
            }else if(self.isSinglePDSelected){
                return 140;
            }else{
                return 195;
            }
        }else{
            return  [self.heightsList[indexPath.section] doubleValue];
        }
    }
    
    return  [self.heightsList[indexPath.section] doubleValue];

    
    
    
    
  /*  if (self.isRegularLensCategorySelected&&self.isContactLensCategorySelected)
    {
        if (indexPath.section > 2)
        {
            self.computedIndexPathSection = indexPath.section - 1;
        }
    }
    if(indexPath.section == 0)
    {
        return 178;
    }else if(self.computedIndexPathSection == 1){
        return 102;
    }else if (self.computedIndexPathSection == self.numberOfSections -1){
        return 136;
    }else if (self.computedIndexPathSection == 2&&self.isContactLensCategorySelected&&!self.isBifocalContactLensSelected&&!self.isRegularContactLensSelected&&!self.isAstigmatismSelected){
        return 145;
    }else if (self.computedIndexPathSection == 2&&self.isContactLensCategorySelected&&self.isBifocalContactLensSelected&&!self.isRegularContactLensSelected&&!self.isAstigmatismSelected){
        return  435;
    }else if (self.computedIndexPathSection == 2&&self.isContactLensCategorySelected&&!self.isBifocalContactLensSelected&&self.isRegularContactLensSelected&&!self.isAstigmatismSelected){
        if (self.isRegularLensCategorySelected){
            return 145;
        }
        return 285;
    }else if (self.computedIndexPathSection == 2&&self.isContactLensCategorySelected&&!self.isBifocalContactLensSelected&&!self.isRegularContactLensSelected&&self.isAstigmatismSelected){
        if (self.isRegularLensCategorySelected){
            return 145;
        }
        return   435;//500;
    }
    else if(self.computedIndexPathSection == 3&&self.isContactLensCategorySelected){
        return 120; // only tis is original fix me

    }else if(self.computedIndexPathSection == 2&&self.isRegularLensCategorySelected){
        return 95;
    }else if(self.computedIndexPathSection == 3&&self.isRegularLensCategorySelected){
        return 140;// only tis is original fix me
    }else if(self.computedIndexPathSection == 4&&self.isRegularLensCategorySelected){
        return 140;
    }else if(self.computedIndexPathSection == 7&&self.isRegularLensCategorySelected){
        return 120;
    }else if(self.computedIndexPathSection == 5&&self.isRegularLensCategorySelected&&!self.isPrismSelected){ // Check for which is selected no or none
        return 80;
    }
    else if(self.computedIndexPathSection == 5&&self.isRegularLensCategorySelected&&self.isPrismSelected){ // Check for which is selected no or none
        return 227;
    }else if(self.computedIndexPathSection == 6&&self.isRegularLensCategorySelected
             &&!self.isSinglePDSelected&&!self.isDualPDSelected){ // Check for which is selected no or none
        return 73;
    }else if(self.computedIndexPathSection == 6&&self.isRegularLensCategorySelected
             &&self.isSinglePDSelected&&!self.isDualPDSelected){ // Check for which is selected no or none
        return 140;
    }else if(self.computedIndexPathSection == 6&&self.isRegularLensCategorySelected
             &&!self.isSinglePDSelected&&self.isDualPDSelected){ // Check for which is selected no or none
        return 195;
    }
    
    
//    if (indexPath.section == 2&&_isContactLensCategorySelected){
//        return 130;
//    }
    return  [self.heightsList[indexPath.section] doubleValue];*/
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0];
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        PersonDetailsTableViewCell *cell = (PersonDetailsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MedicalDetails" forIndexPath:indexPath];
        cell.layer.masksToBounds = YES;
        
        if (self.editableDetails){
            cell.dateLabel.text = [[self.editableDetails valueForKey:@"prescriptionInfo"] valueForKey:@"date"];
            cell.nameLbl.enabled = false;
        }else{
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateStyle:NSDateFormatterLongStyle]; // day, Full month and year
            [df setTimeStyle:NSDateFormatterNoStyle];  // nothing
            NSString *date = [df stringFromDate:[NSDate date]];
            cell.dateLabel.text = date;
            [self.personalDetails setValue:date forKey:@"date"];
        }
        cell.layer.cornerRadius = 4.0f;
        cell.backgroundColor = [UIColor whiteColor];
        UITextField *prescriptionTextField = (UITextField*)[cell viewWithTag:NAME_TAG];
        prescriptionTextField.delegate = self;
        if (self.editableDetails){
            NSDictionary *personalDetails = [self.editableDetails valueForKey:@"prescriptionInfo"];
             cell.nameLbl.text = [personalDetails valueForKey:@"name"];
             cell.doctorNameLbl.text = [personalDetails valueForKey:@"doctorName"];
        }
        if (self.isFirstTime)
        {
            self.isFirstTime = NO;
            [prescriptionTextField becomeFirstResponder];
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {
        LensCategoryTableViewCell *cell = (LensCategoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"LensCategoryTableViewCell" forIndexPath:indexPath];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 4.0f;
        cell.backgroundColor = [UIColor whiteColor];
        if (self.editableDetails){
            NSDictionary *contactLensDetails = [self.editableDetails valueForKey:@"prescriptionContactLens"];
            if (contactLensDetails){
                [cell.contactlensBtn setSelected:YES];
                [cell.contactlensBtn setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateSelected];
            }
            NSDictionary *regularLensDetails = [self.editableDetails valueForKey:@"prescriptionGlasses"];
            if (regularLensDetails){
                [cell.regularLensBtn setSelected:YES];
                [cell.regularLensBtn setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateSelected];
            }
        }
        return cell;
    }else if(indexPath.section == 2&&self.isContactLensCategorySelected){
        ContactLensPrescriptionTableViewCell *cell = (ContactLensPrescriptionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ContactLensPrescriptionTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 4.0f;
        UIButton *btn = (UIButton*)[cell viewWithTag:5];
        NSDictionary *contactLensDetails = [self.editableDetails valueForKey:@"prescriptionContactLens"];
        if (contactLensDetails){
            NSDictionary *powerDetails = [contactLensDetails valueForKey:@"power"];
            NSDictionary *bcDetails = [contactLensDetails valueForKey:@"bc"];
            NSDictionary *diaDetails = [contactLensDetails valueForKey:@"dia"];
            [cell.powerRightBtn setTitle:[powerDetails valueForKey:@"od"] forState:UIControlStateNormal];
            [cell.powerLeftBtn setTitle:[powerDetails valueForKey:@"os"] forState:UIControlStateNormal];
            [cell.bcRightBtn setTitle:[bcDetails valueForKey:@"od"] forState:UIControlStateNormal];
            [cell.bcLeftBtn setTitle:[bcDetails valueForKey:@"os"] forState:UIControlStateNormal];
            [cell.diaRightBtn setTitle:[diaDetails valueForKey:@"od"] forState:UIControlStateNormal];
            [cell.diaLeftBtn setTitle:[diaDetails valueForKey:@"os"] forState:UIControlStateNormal];
            }
        if (self.isRegularContactLensSelected)
        {
            [btn setTitle:@"Regular Contacts" forState:UIControlStateNormal];
            [self.contactLensDetails setValue:@"Regular Contacts" forKey:@"contactType"];
            
        }else if(self.isBifocalContactLensSelected)
        {
            NSDictionary *addDetails = [contactLensDetails valueForKey:@"add"];
            if ((contactLensDetails) && (addDetails)){
                [cell.cylinderOrAddLefthBtn setTitle:[addDetails valueForKey:@"os"] forState:UIControlStateNormal];
                [cell.cylinderOrAddRigthBtn setTitle:[addDetails valueForKey:@"od"] forState:UIControlStateNormal];
            }
            [btn setTitle:@"Bifocal Contacts" forState:UIControlStateNormal];
            [self.contactLensDetails setValue:@"Bifocal Contacts" forKey:@"contactType"];
            UIButton *axisRightBtn = (UIButton*)[cell viewWithTag:19];
            UIButton *axisLeftBtn  = (UIButton*)[cell viewWithTag:25];
            [axisLeftBtn setHidden:YES];
            [axisRightBtn setHidden:YES];
            [cell.axisLabel setHidden:YES];
            [cell.axisInfoBtn setHidden:YES];
            [cell.cylinderOrAddLabel setText:@"add"];
        }else if(self.isAstigmatismSelected)
        {
            NSDictionary *cylinderDetails = [contactLensDetails valueForKey:@"cylinder"];
            NSDictionary *axisDetails = [contactLensDetails valueForKey:@"axis"];
            if (cylinderDetails && axisDetails){
                [cell.cylinderOrAddLefthBtn setTitle:[cylinderDetails valueForKey:@"os"] forState:UIControlStateNormal];
                [cell.cylinderOrAddRigthBtn setTitle:[cylinderDetails valueForKey:@"od"] forState:
                 UIControlStateNormal];
                [cell.axisRigthBtn setTitle:[axisDetails valueForKey:@"od"] forState:UIControlStateNormal];
                [cell.axisLeftBtn setTitle:[axisDetails valueForKey:@"os"] forState:
                 UIControlStateNormal];
            }
            
            [self.contactLensDetails setValue:@"Astigmatism" forKey:@"contactType"];
            [btn setTitle:@"Astigmatism" forState:UIControlStateNormal];
        }else
        {
            [self.contactLensDetails setValue:@"" forKey:@"contactType"];
            [btn setTitle:@"select" forState:UIControlStateNormal];
        }
        [btn layoutIfNeeded];
        
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else if ((indexPath.section == 3&&self.isContactLensCategorySelected&&!self.isRegularLensCategorySelected)){
        NotesTableViewCell *cell = (NotesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NotesTableViewCell" forIndexPath:indexPath];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 4.0f;
        cell.delegate = self;
        if (self.editableDetails)
        {
            if([[self.neededConfiguration objectForKey:@"prescriptionInfo"] objectForKey:@"notes"])
            {
                cell.notesDescLbl.text = [[self.neededConfiguration objectForKey:@"prescriptionInfo"] objectForKey:@"notes"];
            }
        }
         
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else if((indexPath.section == 2&&self.isRegularLensCategorySelected&&!self.isContactLensCategorySelected)
             ||((indexPath.section == 3&&self.isRegularLensCategorySelected&&self.isContactLensCategorySelected))){
        PrescriptionTypeTableViewCell *cell = (PrescriptionTypeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"PrescriptionTypeTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 4.0f;
        cell.backgroundColor = [UIColor whiteColor];
        if (self.editableDetails){
            if ([self.editableDetails valueForKey:@"prescriptionGlasses"]){
                [cell.prescriptionTypeBtn  setTitle:[[self.editableDetails valueForKey:@"prescriptionGlasses"] valueForKey:@"type"] forState:UIControlStateNormal];
            }
        }
        return cell;
    }else if((indexPath.section == 3&&self.isRegularLensCategorySelected&&!self.isContactLensCategorySelected)
             ||((indexPath.section == 4&&self.isRegularLensCategorySelected&&self.isContactLensCategorySelected)))
    {
        LensPowerTableViewCell *cell = (LensPowerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"LensPowerTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 4.0f;
        if (self.editableDetails){
            if ([self.editableDetails valueForKey:@"prescriptionGlasses"]){
                NSDictionary *sphere = [[self.editableDetails valueForKey:@"prescriptionGlasses"] valueForKey:@"sphere"];
                NSDictionary *cylinder = [[self.editableDetails valueForKey:@"prescriptionGlasses"] valueForKey:@"cylinder"];
                [cell.sphereRightBtn setTitle:[sphere valueForKey:@"od"] forState:UIControlStateNormal];
                [cell.sphereLeftBtn setTitle:[sphere valueForKey:@"os"] forState:UIControlStateNormal];
                [cell.cylinderRightBtn setTitle:[cylinder valueForKey:@"od"] forState:UIControlStateNormal];
                [cell.cylinderLeftBtn setTitle:[cylinder valueForKey:@"os"] forState:UIControlStateNormal];
            }
        }
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else if((indexPath.section == 4&&self.isRegularLensCategorySelected&&!self.isContactLensCategorySelected)
             ||((indexPath.section == 5&&self.isRegularLensCategorySelected&&self.isContactLensCategorySelected))){
        LensAxisTableViewCell *cell = (LensAxisTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"LensAxisTableViewCell" forIndexPath:indexPath];
        cell.layer.masksToBounds = YES;
         
        cell.delegate = self;
        if (self.editableDetails){
            if ([self.editableDetails valueForKey:@"prescriptionGlasses"]){
                NSDictionary *axis = [[self.editableDetails valueForKey:@"prescriptionGlasses"] valueForKey:@"axis"];
                NSDictionary *add = [[self.editableDetails valueForKey:@"prescriptionGlasses"] valueForKey:@"add"];
                [cell.lensAxisRigthBtn setTitle:[axis valueForKey:@"od"] forState:UIControlStateNormal];
                [cell.lensAxisLeftBtn setTitle:[axis valueForKey:@"os"] forState:UIControlStateNormal];
                [cell.lensAddLeftBtn setTitle:[add valueForKey:@"os"] forState:UIControlStateNormal];
                [cell.lensAddRigthBtn setTitle:[add valueForKey:@"od"] forState:UIControlStateNormal];
            }
        }
        cell.layer.cornerRadius = 4.0f;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else if((indexPath.section == 5 && self.isRegularLensCategorySelected&&!self.isContactLensCategorySelected)
             ||(indexPath.section == 6 && self.isRegularLensCategorySelected&&self.isContactLensCategorySelected)){
        PrismValuesTableViewCell *cell = (PrismValuesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"PrismValuesTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 4.0f;
        if (self.prismSelectionType == YES_SELECTED){
            [cell.yesBtn setImage:[UIImage imageNamed:@"select_check-mark"] forState:UIControlStateSelected];
            [cell.yesBtn setSelected:YES];
            if (self.editableDetails){
                if ([self.editableDetails valueForKey:@"prescriptionGlasses"]){
                    NSDictionary *prism = [[self.editableDetails valueForKey:@"prescriptionGlasses"] valueForKey:@"prismValues"];
                    NSDictionary *base = [[self.editableDetails valueForKey:@"prescriptionGlasses"] valueForKey:@"base"];
                    [cell.prismRightBtn setTitle:[prism valueForKey:@"prismOd"] forState:UIControlStateNormal];
                    [cell.prismLeftBtn setTitle:[prism valueForKey:@"prismOs"] forState:UIControlStateNormal];
                    [cell.baseRightBtn setTitle:[base valueForKey:@"od"] forState:UIControlStateNormal];
                    [cell.baseLeftBtn setTitle:[base valueForKey:@"os"] forState:UIControlStateNormal];
                }
            }
        }else if(self.prismSelectionType == NO_SELECTED){
            [cell.noBtn
             setImage:[UIImage imageNamed:@"select_check-mark"] forState:UIControlStateNormal];
            [cell.yesBtn setImage:[UIImage imageNamed:@"unselected_radiobutton"] forState:UIControlStateSelected];
        }else{
            [cell.yesBtn setImage:[UIImage imageNamed:@"unselected_radiobutton"] forState:UIControlStateSelected];
            [cell.noBtn
             setImage:[UIImage imageNamed:@"unselected_radiobutton"] forState:UIControlStateNormal];
        }
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else if((indexPath.section == 6 && self.isRegularLensCategorySelected&&!self.isContactLensCategorySelected)
             ||(indexPath.section == 7 && self.isRegularLensCategorySelected&&self.isContactLensCategorySelected)){
        PupillaryTableViewCell *cell = (PupillaryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"PupillaryTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 4.0f;
        NSDictionary *signlePD = [[[self.editableDetails valueForKey:@"prescriptionGlasses"] valueForKey:@"pd"] valueForKey:@"singlePd"];
        NSDictionary *dualPD = [[[self.editableDetails valueForKey:@"prescriptionGlasses"] valueForKey:@"pd"] valueForKey:@"dualPd"];
        if (self.isSinglePDSelected){
            [cell.singlePDBtn setImage:[UIImage imageNamed:@"select_check-mark"] forState:UIControlStateNormal];
            [cell.dualPDBtn setImage:[UIImage imageNamed:@"unselected_radiobutton"] forState:UIControlStateNormal];
            
            [cell.pdTitleLabel setText:@"select pd"];
            [cell.rightLabel setHidden:YES];
            [cell.leftLabel setHidden:YES];
            [cell.leftPDBtn setHidden:YES];
            
            if (self.editableDetails){
                [cell.rightPDBtn setTitle:signlePD forState:UIControlStateNormal];
            }
        }else if(self.isDualPDSelected){
            [cell.singlePDBtn setImage:[UIImage imageNamed:@"unselected_radiobutton"] forState:UIControlStateNormal];
            [cell.dualPDBtn setImage:[UIImage imageNamed:@"select_check-mark"] forState:UIControlStateNormal];
            
            [cell.pdTitleLabel setText:@"pd"];
            [cell.rightLabel setHidden:NO];
            [cell.leftLabel setHidden:NO];
            [cell.leftPDBtn setHidden:NO];

            if (self.editableDetails){
                [cell.rightPDBtn setTitle:[dualPD valueForKey:@"od"] forState:UIControlStateNormal];
                [cell.leftPDBtn setTitle:[dualPD valueForKey:@"os"] forState:UIControlStateNormal];
            }
        }else{
            [cell.singlePDBtn setImage:[UIImage imageNamed:@"unselected_radiobutton"] forState:UIControlStateNormal];
            [cell.dualPDBtn setImage:[UIImage imageNamed:@"unselected_radiobutton"] forState:UIControlStateNormal];

        }
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
       
    }else if((indexPath.section == 7 && self.isRegularLensCategorySelected&&!self.isContactLensCategorySelected)||(indexPath.section == 8 &&self.isRegularLensCategorySelected&&self.isContactLensCategorySelected)){
        NotesTableViewCell *cell = (NotesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NotesTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell.notesDescLbl setText:[[self.neededConfiguration valueForKey:@"prescriptionInfo"] valueForKey:@"notes"]];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 4.0f;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else if((indexPath.section == 8&& self.isRegularLensCategorySelected&&!self.isContactLensCategorySelected)||(indexPath.section == 9&&self.isContactLensCategorySelected&&self.isRegularLensCategorySelected)){
        LensTypeTableViewCell *cell = (LensTypeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"LensTypeTableViewCell" forIndexPath:indexPath];
        if (self.editableDetails){
            if ([self.regularLensDetails objectForKey:@"specialGlass"]){
                NSLog(@"SG::%@",[self.regularLensDetails objectForKey:@"specialGlass"]);
                NSArray *specialGlasses = [self.regularLensDetails objectForKey:@"specialGlass"];
                if ([specialGlasses containsObject:@"photo brown"]){
                    [cell.brownBtn setSelected:YES];
                    [cell.brownBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                }
                if ([specialGlasses containsObject:@"polycarbonite"]){
                    [cell.polyBtn setSelected:YES];
                    [cell.polyBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                }
                if ([specialGlasses containsObject:@"single vision"]){
                    [cell.singleBtn setSelected:YES];
                    [cell.singleBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                }
                if ([specialGlasses containsObject:@"anti reflective"]){
                    [cell.antireflctBtn setSelected:YES];
                    [cell.antireflctBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                }
                if ([specialGlasses containsObject:@"high index plastic"]){
                    [cell.highIndexBtn setSelected:YES];
                    [cell.highIndexBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                }
                if ([specialGlasses containsObject:@"scratch resistant"]){
                    [cell.scratchBtn setSelected:YES];
                    [cell.scratchBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                }
                if ([specialGlasses containsObject:@"photo chromic"]){
                    [cell.chromicBtn setSelected:YES];
                    [cell.chromicBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                }
                if ([specialGlasses containsObject:@"uv protection"]){
                    [cell.UVBtn setSelected:YES];
                    [cell.UVBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                }
            }
        }
        
        
        cell.delegate = self;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 4.0f;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else if (indexPath.section == self.numberOfSections -1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavePrescription" forIndexPath:indexPath];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 4.0f;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
        return nil;
    }
    
    
    
//    [cell.contentView.layer setBorderColor:[UIColor grayColor].CGColor];
//    [cell.contentView.layer setBorderWidth:1.0f];
    
    
   // return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 15.0;
//}

-(void)notesBegin
{
    [self removePickerView];
    [self removeDatePickerView];
}

-(void)notesText:(NSString*)notesText
{
    if (self.editableDetails){
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *oldDict = [self.editableDetails valueForKey:@"prescriptionInfo"];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setValue:notesText forKey:@"notes"];
        [self.neededConfiguration setValue:newDict forKey:@"prescriptionInfo"];
        [self.editableDetails setValue:newDict forKey:@"prescriptionInfo"];
        self.personalDetails = newDict;
    }else{
        [[self.neededConfiguration objectForKey:@"prescriptionInfo"] setObject:notesText forKey:@"notes"];

    }
}

- (IBAction)dateClicked:(id)sender {
    [self.view endEditing:YES];
    [self showDatePicker:sender];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    [self removePickerView];
    [self removeDatePickerView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)prismValueSelected:(BOOL)yesOrNo cell:(PrismValuesTableViewCell*)cell
{
  
    if(yesOrNo) // YES
    {
        self.isPrismSelected = !self.isPrismSelected;
        if (self.isPrismSelected){
            [self.regularLensDetails setValue:self.regularPrismDetails forKey:@"prismValues"];
            self.prismSelectionType = YES_SELECTED;
        }else{
            if ([self.regularLensDetails objectForKey:@"prismValues"])
            [self.regularLensDetails removeObjectForKey:@"prismValues"];
            self.prismSelectionType = NONE;
        }
        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
        [self reloadTableAtIndexPath:indexPath completionHandler:^(BOOL success) {
            
        }];
    }else if (self.isPrismSelected&&!yesOrNo){
        self.isPrismSelected = NO;
        if ([self.regularLensDetails objectForKey:@"prismValues"])
        [self.regularLensDetails removeObjectForKey:@"prismValues"];
        self.prismSelectionType = NO_SELECTED;
        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
        [self reloadTableAtIndexPath:indexPath completionHandler:^(BOOL success) {
            
        }];
    }
    else{
        if (self.prismSelectionType == NO_SELECTED)
        {
            self.prismSelectionType = NONE;
            if ([self.regularLensDetails objectForKey:@"prismValues"])
            [self.regularLensDetails removeObjectForKey:@"prismValues"];
            [cell.noBtn setImage:[UIImage imageNamed:@"unselected_radiobutton"] forState:UIControlStateNormal];
        }else{
            self.prismSelectionType = NO_SELECTED;
            [cell.noBtn setImage:[UIImage imageNamed:@"select_check-mark"] forState:UIControlStateNormal];
        }
    }
}

-(void)pupillarySelected:(PDSelctionType)type cell:(PupillaryTableViewCell*)cell;
{
        if (type == SINGLE_PD_SELECTED){
            self.isSinglePDSelected = !self.isSinglePDSelected;
            self.isDualPDSelected = NO;
            [self.regularLensDetails removeObjectForKey:@"pd"];
            [self.regularLensDetails setValue:[NSNumber numberWithBool:false] forKey:@"isDualPd"];
            
            NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
            [self reloadTableAtIndexPath:indexPath completionHandler:^(BOOL success) {
                
            }];
        }else if (type == DUAL_PD_SELECTED){
            self.isDualPDSelected = !self.isDualPDSelected;
            [self.regularLensDetails setValue:[NSNumber numberWithBool:self.isDualPDSelected] forKey:@"isDualPd"];
            [self.regularLensDetails removeObjectForKey:@"pd"];

            self.isSinglePDSelected = NO;
            NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
            [self reloadTableAtIndexPath:indexPath completionHandler:^(BOOL success) {
                
            }];
        }else{
            [self.regularLensDetails removeObjectForKey:@"dualPd"];
            [self.regularLensDetails removeObjectForKey:@"singlePd"];
            self.isSinglePDSelected = NO;
            self.isDualPDSelected = NO;
            [self.regularLensDetails setValue:[NSNumber numberWithBool:false] forKey:@"isDualPd"];
        }
}


-(void)reloadTableAtIndexPath:(NSIndexPath*)indexPath completionHandler:(nullable void(^)(BOOL success))completionHandler;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CATransaction begin];
        [CATransaction setCompletionBlock: ^{
            // Code to be executed upon completion
            completionHandler(YES);
        }];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [CATransaction commit];
    });
}

-(IBAction)dismiss:(id)sender
{
    [FIRAnalytics logEventWithName:@"BTN_CLICK_CLOSE_PRESP"
                        parameters:@{
                                     kFIRParameterItemID:@"BTN_CLICK_CLOSE_PRESP",
                                     kFIRParameterItemName:@"Close Prescription",
                                     kFIRParameterContentType:@"text"
                                     }];

    [self removePickerView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showPopupWithContent:(NSString*)content
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@""
                                                                                               message:content
                                                             preferredStyle:UIAlertControllerStyleAlert];;
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alertC addAction:defaultAction];
    [self presentViewController:alertC animated:NO completion:nil];

}

- (IBAction)contactLensTapped:(id)sender {
    [self.view endEditing:YES];
    [self removePickerView];
    [self removeDatePickerView];
    UIButton *btn = (UIButton*)sender;
    if ([sender isSelected]){
        if ([self.neededConfiguration valueForKey:@"prescriptionContactLens"]){
            if ([self.editableDetails valueForKey:@"prescriptionContactLens"]){
                [self.contactLensDetails removeAllObjects];
            }
            [self.neededConfiguration removeObjectForKey:@"prescriptionContactLens"];
        }
        self.isContactLensCategorySelected = NO;
        [self.neededConfiguration setValue:[NSNumber numberWithBool:false] forKey:@"contactLens"];
        [sender setSelected:NO];
        [btn setImage:[UIImage imageNamed:@"unchecked"]forState:UIControlStateNormal];
        NSIndexSet *indexSet;
        if (self.isRegularLensCategorySelected){
            self.numberOfSections = self.numberOfSections - 1;
            indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 1)];
        }else{
            self.numberOfSections = self.numberOfSections - 2;
            indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }else{
        NSMutableDictionary *contactDetails = [self.neededConfiguration valueForKey:@"prescriptionContactLens"];
        if (contactDetails == nil){
            if (self.editableDetails){
                self.contactLensDetails = [[NSMutableDictionary alloc] init];
            }
            [self.neededConfiguration setObject:self.contactLensDetails forKey:@"prescriptionContactLens"];
        }
        self.isContactLensCategorySelected = YES;
        [self.neededConfiguration setValue:[NSNumber numberWithBool:true] forKey:@"contactLens"];
        [sender setSelected:YES];
        [btn setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateSelected];
        NSIndexSet *indexSet;
        if (self.isRegularLensCategorySelected)
        {
            self.numberOfSections = self.numberOfSections + 1;
            indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 1)];

        }else{
            self.numberOfSections = self.numberOfSections + 2;
            indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)];

        }
        [self.tableView beginUpdates];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
    LensCategoryTableViewCell *categoryCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    [categoryCell.lensCategoryLabel setTextColor:[UIColor colorWithRed:30/255.0 green:184.0/255.0 blue:207/255.0 alpha:1.0]];
    [categoryCell layoutIfNeeded];

    

}



- (IBAction)regularLensCategoryTapped:(id)sender {
    [self removeDatePickerView];
    [self removePickerView];
    [self.view endEditing:YES];
    UIButton *btn = (UIButton*)sender;
    if ([sender isSelected]){
        if ([self.neededConfiguration valueForKey:@"prescriptionGlasses"]){
            if ([self.editableDetails valueForKey:@"prescriptionGlasses"]){
                [self.regularLensDetails removeAllObjects];
            }
            [self.neededConfiguration removeObjectForKey:@"prescriptionGlasses"];
        }
        self.isRegularLensCategorySelected = NO;
        [self.neededConfiguration setValue:[NSNumber numberWithBool:false] forKey:@"regularLens"];
        [sender setSelected:NO];
        [btn setImage:[UIImage imageNamed:@"unchecked"]forState:UIControlStateNormal];
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        if (self.isContactLensCategorySelected)
        {
            self.numberOfSections = self.numberOfSections - 6;
            [indexSet addIndex:3];
            [indexSet addIndex:4];
            [indexSet addIndex:5];
            [indexSet addIndex:6];
            [indexSet addIndex:7];
            [indexSet addIndex:9];

        }else{
            self.numberOfSections = self.numberOfSections - 7;
            [indexSet addIndex:2];
            [indexSet addIndex:3];
            [indexSet addIndex:4];
            [indexSet addIndex:5];
            [indexSet addIndex:6];
            [indexSet addIndex:7];
            [indexSet addIndex:8];
        }
       
        [self.tableView beginUpdates];
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }else{
        
        NSMutableDictionary *contactDetails = [self.neededConfiguration valueForKey:@"prescriptionGlasses"];
        if (contactDetails == nil){
            if (self.editableDetails){
                self.regularLensDetails = [[NSMutableDictionary alloc] init];
            }
            
            [self.neededConfiguration setObject:self.regularLensDetails forKey:@"prescriptionGlasses"];
        }
        self.isRegularLensCategorySelected = YES;
        [self.neededConfiguration setValue:[NSNumber numberWithBool:true] forKey:@"regularLens"];
        [sender setSelected:YES];
        [btn setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateSelected];
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        if (self.isContactLensCategorySelected)
        {
            self.numberOfSections = self.numberOfSections + 6;
            [indexSet addIndex:3];
            [indexSet addIndex:4];
            [indexSet addIndex:5];
            [indexSet addIndex:6];
            [indexSet addIndex:7];
            [indexSet addIndex:9];

        }else{
            self.numberOfSections = self.numberOfSections + 7;
            [indexSet addIndex:2];
            [indexSet addIndex:3];
            [indexSet addIndex:4];
            [indexSet addIndex:5];
            [indexSet addIndex:6];
            [indexSet addIndex:7];
            [indexSet addIndex:8];

        }
        
       // NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 4)];
        [self.tableView beginUpdates];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
    }
    
    LensCategoryTableViewCell *categoryCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    [categoryCell.lensCategoryLabel setTextColor:[UIColor colorWithRed:30/255.0 green:184.0/255.0 blue:207/255.0 alpha:1.0]];
    [categoryCell layoutIfNeeded];
}



-(IBAction)showPopupForSphere:(id)sender
{
    [self showPopupWithContent:@"Sphere(SPH). is the amount of lens power, measured in diopters(D), prescribed to correct nearsightedness or farsightedness. If the number of appearing under this heading has a minus sign(-), you are nearsighted; if teh number has a plus sign(+) or is not preceded by a plus sign or a minun sign, you are farsighted. Make sure to select the correct sign(+/-) while ordering."];
}

-(IBAction)showPopupForCylinder:(id)sender
{
    [self showPopupWithContent:@"Cylinder(CYL). is the amount of lens power for astigmatism. If nothing appears in this column, you have no astigmatism and you can leave it blank. Make sure to select correct sign(+/-) while ordering"];
}


-(IBAction)showPopupForAxis:(id)sender
{
    [self showPopupWithContent:@"Axis describes the lens meridian that contains no cylinder power to correct astigmatism. The axis is defined with a number from 1 to 180. If an eyeglass prescription includes cylinder power, it also must include an axis value, which follows the cyl power and is preceded by an x when written freehand."];
}


-(IBAction)showPopupForAdd:(id)sender
{
    [self showPopupWithContent:@"ADD. is the added magnifying power applied to the bottom part of multifocal lenses to correct reading vision. The number appearing in the section of the prescription is always a plus power, even if it is not preceded by a plus sign. Generally, it will range from +1.00 to +3.00."];
}


-(IBAction)showPopupForPrism:(id)sender
{
    [self showPopupWithContent:@"Prism is the amount of prismatic power, measured in prism diopters(or a superscript triangle when written freehand), prescribed to compensate for eye alignment problems. Only a small percentage of eyeglass precriptions include prism. When present, the amount of prism is indicated in either metric or fractional English units(0.5 or 1/2, for example), and the direction of the prism is indicated by noting the relative position of its base or thickest edge. Four abbreviations are used for prism direction: BU = base up; BD = base down; BI - base in(toward the wearer's nose); BO = base out(toward the wearer's ear)."];
}



-(IBAction)showPopupForPower:(id)sender
{
    [self showPopupWithContent:@"Power,\n Sometimes called 'sphere' or 'strength'. Measured in diopters, it is always preceded by a + (plus) or a -(minus) and goes up in 0.25 increments."];
}

-(IBAction)showPopupForBC:(id)sender
{
    [self showPopupWithContent:@"BC,\n The shape of the back surface of the lens, which determines how the lens fits. It is usually an 8.x or 9.x number. A few brands use non-numeric base curves such as flat, median, or steep."];
}

-(IBAction)showPopupForDia:(id)sender
{
    [self showPopupWithContent:@"DIA,\n Refers to the width across the lens in millimeters. Most brands come in one or two sizes. It is usually a 14.x number, but can range from 13.x to 15.x."];
}


-(IBAction)showPopupForPupillary:(id)sender
{
    [self showPopupWithContent:@"Pupillary is the ...."];
}

-(void)removePickerView
{
    [self.pickerViewController removeFromParentViewController];
    [self.pickerViewController.view removeFromSuperview];
    self.pickerViewController = nil;
}

-(void)removeDatePickerView
{
    [self.datePickerViewController removeFromParentViewController];
    [self.datePickerViewController.view removeFromSuperview];
    self.datePickerViewController = nil;
}

-(void)pickerViewController:(DatePickerViewController *)pv didSelectDate:(NSString *)date
{
    [self removeDatePickerView];
    PersonDetailsTableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.tappedIndexPath];
    cell.dateLabel.text = date;
    self.date = date;
    [self.personalDetails setValue:date forKey:@"date"];
    NSLog(@"date %@",date);
}

-(void)pickerViewController:(PickerViewController *)pv didSelectItem:(NSString *)item
{
    [self.view endEditing:YES];
    [self removePickerView];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.tappedIndexPath];
    UIButton *btn = (UIButton*)[cell viewWithTag:self.tappedTag];
    
    NSLog(@"BTN TAG %ld",(long)btn.tag);
    if (btn.tag == 5)
    {
        if ([item isEqualToString:@"Regular Contacts"]){
            [self.contactLensDetails setValue:@"Regular Contacts" forKey:@"contactType"];
            self.isRegularContactLensSelected = YES;
            self.isAstigmatismSelected = NO;
            self.isBifocalContactLensSelected = NO;
        }else if([item isEqualToString:@"Bifocal Lenses"]){
            [self.contactLensDetails setValue:@"Bifocal Contacts" forKey:@"contactType"];
            self.isRegularContactLensSelected = NO;
            self.isAstigmatismSelected = NO;
            self.isBifocalContactLensSelected = YES;
        }else{
            [self.contactLensDetails setValue:@"Astigmatism" forKey:@"contactType"];
            self.isRegularContactLensSelected = NO;
            self.isAstigmatismSelected = YES;
            self.isBifocalContactLensSelected = NO;
        }
        [self  reloadTableAtIndexPath:self.tappedIndexPath completionHandler:^(BOOL success) {
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.tappedIndexPath];
            UIButton *btn = (UIButton*)[cell viewWithTag:self.tappedTag];
            [btn setTitle:item forState:UIControlStateNormal];
        }];
        [self.contactLensDetails setValue:item forKey:@"contactType"];
    }else{
        [btn setTitle:item forState:UIControlStateNormal];
        if (btn.tag == POWER_RIGHT) // Right POWER
        {
            if ([self.contactLensDetails objectForKey:@"power"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.contactLensDetails objectForKey:@"power"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"od"];
                    [self.contactLensDetails setObject:newDict forKey:@"power"];
                }else{
                    [[self.contactLensDetails objectForKey:@"power"]  setValue:item forKey:@"od"];
                }
            }else{
                NSMutableDictionary *powerDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.contactLensDetails setObject:powerDetails forKey:@"power"];
                [powerDetails setValue:item forKey:@"od"];
            }
            
        }else if(btn.tag == POWER_LEFT) // LEFT POWER
        {
            if ([self.contactLensDetails objectForKey:@"power"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.contactLensDetails objectForKey:@"power"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"os"];
                    [self.contactLensDetails setObject:newDict forKey:@"power"];
                }else{
                    [[self.contactLensDetails objectForKey:@"power"] setValue:item forKey:@"os"];
                }
            }else{
                NSMutableDictionary *powerDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.contactLensDetails setObject:powerDetails forKey:@"power"];
                [powerDetails setValue:item forKey:@"os"];
            }
        }else if(btn.tag == BC_RIGHT) // BC RIGHT
        {
            if ([self.contactLensDetails objectForKey:@"bc"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.contactLensDetails objectForKey:@"bc"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"od"];
                    [self.contactLensDetails setObject:newDict forKey:@"bc"];
                }else{
                    [[self.contactLensDetails objectForKey:@"bc"]  setValue:item forKey:@"od"];
                }
            }else{
                NSMutableDictionary *bcDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.contactLensDetails setObject:bcDetails forKey:@"bc"];
                [bcDetails setValue:item forKey:@"od"];
            }
        }
        else if(btn.tag == BC_LEFT) //BC  LEFT
        {
            if ([self.contactLensDetails objectForKey:@"bc"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.contactLensDetails objectForKey:@"bc"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"os"];
                    [self.contactLensDetails setObject:newDict forKey:@"bc"];
                }else{
                    [[self.contactLensDetails objectForKey:@"bc"]  setValue:item forKey:@"os"];
                }
            }else{
                NSMutableDictionary *bcDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.contactLensDetails setObject:bcDetails forKey:@"bc"];
                [bcDetails setValue:item forKey:@"os"];
            }
        }
        else if(btn.tag == DIA_RIGHT) // DIA RIGHT
        {
            if ([self.contactLensDetails objectForKey:@"dia"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.contactLensDetails objectForKey:@"dia"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"od"];
                    [self.contactLensDetails setObject:newDict forKey:@"dia"];
                }else{
                    [[self.contactLensDetails objectForKey:@"dia"] setValue:item forKey:@"od"];
                }
                
            }else{
                NSMutableDictionary *diaDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.contactLensDetails setObject:diaDetails forKey:@"dia"];
                [diaDetails setValue:item forKey:@"od"];
            }
            
        }
        else if(btn.tag == DIA_LEFT) // DIA LEFT
        {
            if ([self.contactLensDetails objectForKey:@"dia"]){
                if (self.editableDetails){
                    
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.contactLensDetails objectForKey:@"dia"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"os"];
                    [self.contactLensDetails setObject:newDict forKey:@"dia"];
                }else{
                    [[self.contactLensDetails objectForKey:@"dia"] setValue:item forKey:@"os"];
                }
                
            }else{
                NSMutableDictionary *diaDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.contactLensDetails setObject:diaDetails forKey:@"dia"];
                [diaDetails setValue:item forKey:@"os"];
            }
        }
        else if(btn.tag == ADD_RIGHT) // ADD RIGHT
        {
            if (self.isAstigmatismSelected){
                if ([self.contactLensDetails objectForKey:@"cylinder"]){
                    if (self.editableDetails){
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        NSDictionary *oldDict = [self.contactLensDetails objectForKey:@"cylinder"];
                        [newDict addEntriesFromDictionary:oldDict];
                        [newDict setValue:item forKey:@"od"];
                        [self.contactLensDetails setObject:newDict forKey:@"cylinder"];
                    }else{
                        [[self.contactLensDetails objectForKey:@"cylinder"] setValue:item forKey:@"od"];
                    }
                }else{
                    NSMutableDictionary *cylinderDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                    [self.contactLensDetails setObject:cylinderDetails forKey:@"cylinder"];
                    [cylinderDetails setValue:item forKey:@"od"];
                }
            }else{
                if ([self.contactLensDetails objectForKey:@"add"]){
                    if (self.editableDetails){
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        NSDictionary *oldDict = [self.contactLensDetails objectForKey:@"add"];
                        [newDict addEntriesFromDictionary:oldDict];
                        [newDict setValue:item forKey:@"od"];
                        [self.contactLensDetails setObject:newDict forKey:@"add"];
                    }else{
                        [[self.contactLensDetails objectForKey:@"add"] setValue:item forKey:@"od"];
                    }
                    
                }else{
                    NSMutableDictionary *addDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                    [self.contactLensDetails setObject:addDetails forKey:@"add"];
                    [addDetails setValue:item forKey:@"od"];
                }
            }
            
            
        }else if(btn.tag == ADD_LEFT) // ADD LEFT
        {
            if (self.isAstigmatismSelected){
                if ([self.contactLensDetails objectForKey:@"cylinder"]){
                    if (self.editableDetails){
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        NSDictionary *oldDict = [self.contactLensDetails objectForKey:@"cylinder"];
                        [newDict addEntriesFromDictionary:oldDict];
                        [newDict setValue:item forKey:@"os"];
                        [self.contactLensDetails setObject:newDict forKey:@"cylinder"];
                    }else{
                        [[self.contactLensDetails objectForKey:@"cylinder"] setValue:item forKey:@"os"];
                    }
                    
                }else{
                    NSMutableDictionary *cylinderDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                    [self.contactLensDetails setObject:cylinderDetails forKey:@"cylinder"];
                    [cylinderDetails setValue:item forKey:@"os"];
                }
            }else{
                if ([self.contactLensDetails objectForKey:@"add"]){
                    if (self.editableDetails){
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                        NSDictionary *oldDict = [self.contactLensDetails objectForKey:@"add"];
                        [newDict addEntriesFromDictionary:oldDict];
                        [newDict setValue:item forKey:@"os"];
                        [self.contactLensDetails setObject:newDict forKey:@"add"];
                    }else{
                        [[self.contactLensDetails objectForKey:@"add"] setValue:item forKey:@"os"];
                    }
                    
                }else{
                    NSMutableDictionary *addDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                    [self.contactLensDetails setObject:addDetails forKey:@"add"];
                    [addDetails setValue:item forKey:@"os"];
                }
            }
        }else if(btn.tag == AXIS_RIGHT) // AXIS RIGHT
        {
            if ([self.contactLensDetails objectForKey:@"axis"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.contactLensDetails objectForKey:@"axis"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"od"];
                    [self.contactLensDetails setObject:newDict forKey:@"axis"];
                }else{
                    [[self.contactLensDetails objectForKey:@"axis"] setValue:item forKey:@"od"];
                }
                
            }else{
                NSMutableDictionary *axisDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.contactLensDetails setObject:axisDetails forKey:@"axis"];
                [axisDetails setValue:item forKey:@"od"];
            }
            
        }else if(btn.tag == AXIS_LEFT)
        {
            if ([self.contactLensDetails objectForKey:@"axis"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.contactLensDetails objectForKey:@"axis"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"os"];
                    [self.contactLensDetails setObject:newDict forKey:@"axis"];
                }else{
                    [[self.contactLensDetails objectForKey:@"axis"] setValue:item forKey:@"os"];
                }
                
            }else{
                NSMutableDictionary *axisDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.contactLensDetails setObject:axisDetails forKey:@"axis"];
                [axisDetails setValue:item forKey:@"os"];
            }
        }
        else if(btn.tag == PRESCRIPTION_TYPE)
        {
            if ([item isEqualToString:@"Distance Lenses"]|| [item isEqualToString:@"Reading Lenses"]){
                self.isDistanceLensSelected = YES;
            }
            [self.regularLensDetails setValue:item forKey:@"type"];
            
        }
        else if(btn.tag == SPHERE_RIGHT)
        {
            if ([self.regularLensDetails objectForKey:@"sphere"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.regularLensDetails objectForKey:@"sphere"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"od"];
                    [self.regularLensDetails setObject:newDict forKey:@"sphere"];
                }else{
                    [[self.regularLensDetails objectForKey:@"sphere"] setValue:item forKey:@"od"];
                }
            }else{
                NSMutableDictionary *sphereDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.regularLensDetails setObject:sphereDetails forKey:@"sphere"];
                [sphereDetails setValue:item forKey:@"od"];
            }
        }
        else if(btn.tag == SPHERE_LEFT)
        {
            if ([self.regularLensDetails objectForKey:@"sphere"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.regularLensDetails objectForKey:@"sphere"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"os"];
                    [self.regularLensDetails setObject:newDict forKey:@"sphere"];
                }else{
                    [[self.regularLensDetails objectForKey:@"sphere"] setValue:item forKey:@"os"];
                }
            }else{
                NSMutableDictionary *sphereDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.regularLensDetails setObject:sphereDetails forKey:@"sphere"];
                [sphereDetails setValue:item forKey:@"os"];
            }
        }
        else if(btn.tag == CYLINDER_RIGHT)
        {
            if ([self.regularLensDetails objectForKey:@"cylinder"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.regularLensDetails objectForKey:@"cylinder"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"od"];
                    [self.regularLensDetails setObject:newDict forKey:@"cylinder"];
                }else{
                    [[self.regularLensDetails objectForKey:@"cylinder"] setValue:item forKey:@"od"];
                }
            }else{
                NSMutableDictionary *cylinderDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.regularLensDetails setObject:cylinderDetails forKey:@"cylinder"];
                [cylinderDetails setValue:item forKey:@"od"];
            }

        }else if(btn.tag == CYLINDER_LEFT)
        {
            if ([self.regularLensDetails objectForKey:@"cylinder"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.regularLensDetails objectForKey:@"cylinder"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"os"];
                    [self.regularLensDetails setObject:newDict forKey:@"cylinder"];
                }else{
                    [[self.regularLensDetails objectForKey:@"cylinder"] setValue:item forKey:@"os"];
                }
            }else{
                NSMutableDictionary *cylinderDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.regularLensDetails setObject:cylinderDetails forKey:@"cylinder"];
                [cylinderDetails setValue:item forKey:@"os"];
            }
        }
        else if(btn.tag == AXIS_REGULAR_RIGHT)
        {
            if ([self.regularLensDetails objectForKey:@"axis"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.regularLensDetails objectForKey:@"axis"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"od"];
                    [self.regularLensDetails setObject:newDict forKey:@"axis"];
                }else{
                    [[self.regularLensDetails objectForKey:@"axis"] setValue:item forKey:@"od"];
                }
            }else{
                NSMutableDictionary *axisDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.regularLensDetails setObject:axisDetails forKey:@"axis"];
                [axisDetails setValue:item forKey:@"od"];
            }
        }else if(btn.tag == AXIS_REGULAR_LEFT)
        {
            if ([self.regularLensDetails objectForKey:@"axis"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.regularLensDetails objectForKey:@"axis"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"os"];
                    [self.regularLensDetails setObject:newDict forKey:@"axis"];
                }else{
                    [[self.regularLensDetails objectForKey:@"axis"] setValue:item forKey:@"os"];
                }
            }else{
                NSMutableDictionary *axisDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.regularLensDetails setObject:axisDetails forKey:@"axis"];
                [axisDetails setValue:item forKey:@"os"];
            }
        }else if(btn.tag == ADD_REGULAR_RIGHT)
        {
            if ([self.regularLensDetails objectForKey:@"add"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.regularLensDetails objectForKey:@"add"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"od"];
                    [self.regularLensDetails setObject:newDict forKey:@"add"];
                }else{
                    [[self.regularLensDetails objectForKey:@"add"] setValue:item forKey:@"od"];
                }
            }else{
                NSMutableDictionary *addDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.regularLensDetails setObject:addDetails forKey:@"add"];
                [addDetails setValue:item forKey:@"od"];
            }

        }else if(btn.tag == ADD_REGULAR_LEFT)
        {
            if ([self.regularLensDetails objectForKey:@"add"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.regularLensDetails objectForKey:@"add"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"os"];
                    [self.regularLensDetails setObject:newDict forKey:@"add"];
                }else{
                    [[self.regularLensDetails objectForKey:@"add"] setValue:item forKey:@"os"];
                }
            }else{
                NSMutableDictionary *addDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.regularLensDetails setObject:addDetails forKey:@"add"];
                [addDetails setValue:item forKey:@"os"];
            }
        }
        else if(btn.tag == PRISM_RIGHT)
        {
            if ([self.regularLensDetails objectForKey:@"prismValues"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.regularLensDetails objectForKey:@"prismValues"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"prismOd"];
                    [self.regularLensDetails setObject:newDict forKey:@"prismValues"];
                }else{
                    [[self.regularLensDetails objectForKey:@"prismValues"] setValue:item forKey:@"prismOd"];
                }
            }else{
                NSMutableDictionary *addDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.regularLensDetails setObject:addDetails forKey:@"prismValues"];
                [addDetails setValue:item forKey:@"prismOd"];
            }
        }else if(btn.tag == PRISM_LEFT)
        {
            if ([self.regularLensDetails objectForKey:@"prismValues"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.regularLensDetails objectForKey:@"prismValues"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"prismOs"];
                    [self.regularLensDetails setObject:newDict forKey:@"prismValues"];
                }else{
                    [[self.regularLensDetails objectForKey:@"prismValues"] setValue:item forKey:@"prismOs"];
                }
            }else{
                NSMutableDictionary *addDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.regularLensDetails setObject:addDetails forKey:@"prismValues"];
                [addDetails setValue:item forKey:@"prismOs"];
            }
        }
        
        else if(btn.tag == 33)
        {
            if ([self.regularLensDetails objectForKey:@"base"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.regularLensDetails objectForKey:@"base"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"od"];
                    [self.regularLensDetails setObject:newDict forKey:@"base"];
                }else{
                    [[self.regularLensDetails objectForKey:@"base"] setValue:item forKey:@"od"];
                }
            }else{
                NSMutableDictionary *addDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.regularLensDetails setObject:addDetails forKey:@"base"];
                [addDetails setValue:item forKey:@"od"];
            }
        }
        else if(btn.tag == 3333){
            if ([self.regularLensDetails objectForKey:@"base"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict = [self.regularLensDetails objectForKey:@"base"];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setValue:item forKey:@"os"];
                    [self.regularLensDetails setObject:newDict forKey:@"base"];
                }else{
                    [[self.regularLensDetails objectForKey:@"base"] setValue:item forKey:@"os"];
                }
            }else{
                NSMutableDictionary *addDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [self.regularLensDetails setObject:addDetails forKey:@"base"];
                [addDetails setValue:item forKey:@"os"];
            }
        }else if(btn.tag == 5678){//right pd
            if ([self.regularLensDetails objectForKey:@"pd"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict;
                    if ([[self.regularLensDetails valueForKey:@"isDualPd"] boolValue]){
                        oldDict = [[self.regularLensDetails objectForKey:@"pd"] objectForKey:@"dualPd"];
                        [newDict addEntriesFromDictionary:oldDict];
                        [newDict setValue:item forKey:@"od"];
                        [self.pdDetails setObject:newDict forKey:@"dualPd"];
                        [self.pdDetails removeObjectForKey:@"singlePd"];
                        [self.regularLensDetails setObject:self.pdDetails forKey:@"pd"];
                    }else{
                        [self.pdDetails setObject:item forKey:@"singlePd"];
                        [self.pdDetails removeObjectForKey:@"dualPd"];

                        [self.regularLensDetails setObject:self.pdDetails forKey:@"pd"];
                    }
                }else{
                    if (self.isSinglePDSelected){
                        [self.pdDetails setValue:item forKey:@"singlePd"];
                        [self.pdDetails removeObjectForKey:@"dualPd"];
                        [self.regularLensDetails setObject:self.pdDetails forKey:@"pd"];
                    }else{
                        [self.pdDetails removeObjectForKey:@"singlePd"];
                        [[self.pdDetails objectForKey:@"dualPd"] setValue:item forKey:@"od"];
                        [self.regularLensDetails setObject:self.pdDetails forKey:@"pd"];
                    }
                }
            }else{
                NSMutableDictionary *pdDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [pdDetails setValue:item forKey:@"od"];
                if (self.isSinglePDSelected){
                    [self.pdDetails setObject:item forKey:@"singlePd"];
                }else{
                    [self.pdDetails setObject:pdDetails forKey:@"dualPd"];
                }
                [self.regularLensDetails setObject:self.pdDetails forKey:@"pd"];
            }
        }else if(btn.tag == 56789){//left pd
            [self.pdDetails removeObjectForKey:@"singlePd"];
            if ([self.regularLensDetails objectForKey:@"pd"]){
                if (self.editableDetails){
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSDictionary *oldDict;
                    if ([[self.regularLensDetails valueForKey:@"isDualPd"] boolValue]){
                        oldDict = [[self.regularLensDetails objectForKey:@"pd"] objectForKey:@"dualPd"];
                        [newDict addEntriesFromDictionary:oldDict];
                        [newDict setValue:item forKey:@"os"];
                        [self.pdDetails setObject:newDict forKey:@"dualPd"];
                        [self.regularLensDetails setObject:self.pdDetails forKey:@"pd"];
                    }
                }else{
                        [[self.pdDetails objectForKey:@"dualPd"] setValue:item forKey:@"os"];
                        [self.regularLensDetails setObject:self.pdDetails forKey:@"pd"];
                }
            }else{
                NSMutableDictionary *pdDetails = [NSMutableDictionary dictionaryWithCapacity:2];
                [pdDetails setValue:item forKey:@"os"];
                [self.pdDetails setObject:pdDetails forKey:@"dualPd"];
                [self.regularLensDetails setObject:self.pdDetails forKey:@"pd"];
            }
        }
    }
    
    //label.text = item;
}


-(void)showDatePicker:(id)sender
{
    [self removePickerView];
    [self.view endEditing:YES];
    UITableViewCell* cell = (UITableViewCell*)[[sender superview] superview];
    // NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    NSIndexPath *indexPaths = [self.tableView indexPathForRowAtPoint:cell.center];
    
    self.tappedIndexPath = indexPaths;
    self.tappedTag = [(UIView*)sender tag];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self removeDatePickerView];
    
    self.datePickerViewController = [storyboard instantiateViewControllerWithIdentifier:@"DatePickerViewController"];
    self.datePickerViewController.delegate = self;
    [self.navigationController addChildViewController:self.datePickerViewController];
    
    self.datePickerViewController.view.frame = CGRectMake(0, screenRect.size.height - self.datePickerViewController.view.frame.size.height, screenRect.size.width, self.datePickerViewController.view.frame.size.height);
    [self.navigationController.view addSubview:self.datePickerViewController.view];

}

-(void)showPickerView:(id)sender withPickerList:(NSArray*)list
{
    [self removeDatePickerView];
    [self.view endEditing:YES];
    UITableViewCell* cell = (UITableViewCell*)[[sender superview] superview];
   // NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    NSIndexPath *indexPaths = [self.tableView indexPathForRowAtPoint:cell.center];

    self.tappedIndexPath = indexPaths;
    self.tappedTag = [(UIView*)sender tag];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self removePickerView];

    self.pickerViewController = [storyboard instantiateViewControllerWithIdentifier:@"PickerViewController"];
    self.pickerViewController.pickerList = list;
    self.pickerViewController.delegate = self;
    [self.navigationController addChildViewController:self.pickerViewController];
    
    self.pickerViewController.view.frame = CGRectMake(0, screenRect.size.height - self.pickerViewController.view.frame.size.height, screenRect.size.width, self.pickerViewController.view.frame.size.height);
    [self.navigationController.view addSubview:self.pickerViewController.view];

}



-(void)prescriptionTypePickerTapped:(id)sender
{
    [self showPickerView:sender withPickerList:@[@"Distance Lenses", @"Reading Lenses", @"Bifocal Lenses", @"Progressive Lenses"]];
}

-(void)contactLensTypePickerTapped:(id)sender
{
    [self showPickerView:sender withPickerList:@[@"Regular Contacts", @"Bifocal Lenses", @"Astigmatism"]];
}

-(IBAction)spherePickerTapped:(id)sender
{
    NSMutableArray *pickerList = [NSMutableArray new];
    for(double d = -15.00; d <= 6.00;)
    {
        if(d < 0)
            [pickerList addObject:[NSString stringWithFormat:@"%.2f", d]];
        else
            [pickerList addObject:[NSString stringWithFormat:@"+%.2f", d]];
        d += 0.25;
    }
    
    [self showPickerView:sender withPickerList:pickerList];
}


-(IBAction)cylinderPickerTapped:(id)sender
{
    NSMutableArray *pickerList = [NSMutableArray new];
    for(double d = -2.25; d <= -0.75;)
    {
        [pickerList addObject:[NSString stringWithFormat:@"%.2f", d]];
        d += 0.50;
    }
    
    [self showPickerView:sender withPickerList:pickerList];
}

-(IBAction)regularLensCylinderPickerTapped:(id)sender
{
    NSMutableArray *pickerList = [NSMutableArray new];
    for(double d = -6.00; d <= +4.00;)
    {
        if(d < 0)
            [pickerList addObject:[NSString stringWithFormat:@"%.2f", d]];
        else
            [pickerList addObject:[NSString stringWithFormat:@"+%.2f", d]];

        d += 0.25;
    }
    
    [self showPickerView:sender withPickerList:pickerList];
}


-(IBAction)axisPickerTapped:(id)sender
{
    NSMutableArray *pickerList = [NSMutableArray new];
    for(NSInteger d = 1; d <= 180;)
    {
        [pickerList addObject:[NSString stringWithFormat:@"%ld", d]];
        d += 1;
    }
    
    [self showPickerView:sender withPickerList:pickerList];
}

- (void)contactLensAxisTapped:(id)sender
{
    NSMutableArray *pickerList = [NSMutableArray new];
    for(NSInteger d = 10; d <= 180;)
    {
        [pickerList addObject:[NSString stringWithFormat:@"%ld", d]];
        d += 10;
    }
    
    [self showPickerView:sender withPickerList:pickerList];

}




-(IBAction)addPickerTapped:(id)sender
{
    NSMutableArray *pickerList = [NSMutableArray new];
    [pickerList addObject:[NSString stringWithFormat:@"+1.00"]];
    [pickerList addObject:[NSString stringWithFormat:@"+2.00"]];
    [pickerList addObject:[NSString stringWithFormat:@"+2.50"]];

    
    [self showPickerView:sender withPickerList:pickerList];
}

-(void)regularlensAddPickerTapped:(id)sender
{
    NSMutableArray *pickerList = [NSMutableArray new];
    for(double d = 0.75; d <= 3.00;)
    {
        [pickerList addObject:[NSString stringWithFormat:@"+%.2f", d]];
        d += 0.25;
    }
    
    [self showPickerView:sender withPickerList:pickerList];
}


-(IBAction)prismPickerTapped:(id)sender
{
    NSMutableArray *pickerList = [NSMutableArray new];
    for(double d = 0.25; d <= 4.00;)
    {
        [pickerList addObject:[NSString stringWithFormat:@"%.2f", d]];
        d += 0.25;
    }
    
    [self showPickerView:sender withPickerList:pickerList];
}

-(IBAction)basePickerTapped:(id)sender
{
    [self showPickerView:sender withPickerList:@[@"in", @"out", @"up", @"down"]];
}

-(IBAction)selectPdPickerTapped:(id)sender
{
    NSMutableArray *pickerList = [NSMutableArray new];
    for(NSInteger d = 55; d <= 80;)
    {
        [pickerList addObject:[NSString stringWithFormat:@"%ld", d]];
        d += 1;
    }
    
    [self showPickerView:sender withPickerList:pickerList];
}

-(IBAction)pdPickerTapped:(id)sender
{
    
    if (self.isSinglePDSelected){
        NSMutableArray *pickerList = [NSMutableArray new];
        for(NSInteger d = 55; d <= 80;)
        {
            [pickerList addObject:[NSString stringWithFormat:@"%ld", d]];
            d += 1;
        }
        [self showPickerView:sender withPickerList:pickerList];
    }else{
        NSMutableArray *pickerList = [NSMutableArray new];
        for(double d = 26.00; d <= 40.00;)
        {
            [pickerList addObject:[NSString stringWithFormat:@"%.2f", d]];
            d += 0.50;
        }
        [self showPickerView:sender withPickerList:pickerList];
    }
    
}

-(void)selectedSpecialGlass:(NSString*)selected
{
    if(self.editableDetails){
        NSMutableArray *specialGlasses = [self.regularLensDetails objectForKey:@"specialGlass"];
        
        if (!specialGlasses){
            specialGlasses = [[NSMutableArray alloc] init];
        }
        else
        {
            specialGlasses = [NSMutableArray arrayWithArray:specialGlasses];
        }
        [specialGlasses addObject:selected];
        [self.regularLensDetails setObject:specialGlasses forKey:@"specialGlass"];

    }else{
        
        NSMutableArray *specialGlasses = [self.regularLensDetails objectForKey:@"specialGlass"];
        if (!specialGlasses){
            specialGlasses = [[NSMutableArray alloc] init];
        }
        [specialGlasses addObject:selected];
        [self.regularLensDetails setObject:specialGlasses forKey:@"specialGlass"];

    }
}
-(void)deSelectedSpecialGlass:(NSString*)deSelected
{
    if ([self.regularLensDetails objectForKey:@"specialGlass"]){
        NSMutableArray *specialGlasses = [NSMutableArray arrayWithArray:[self.regularLensDetails objectForKey:@"specialGlass"]];
        [specialGlasses removeObject:deSelected];
        [self.regularLensDetails setObject:specialGlasses forKey:@"specialGlass"];
        if ([[self.regularLensDetails objectForKey:@"specialGlass"] count] == 0){
            [self.regularLensDetails removeObjectForKey:@"specialGlass"];
        }
    }
}


-(void)contactLensPower:(id)sender  // Contact lens power
{
    NSMutableArray *pickerList = [NSMutableArray new];
    for(double d = -20.00; d <= 20.00;)
    {
        if (d> 0){
            [pickerList addObject:[NSString stringWithFormat:@"+%.2f", d]];
        }else{
            [pickerList addObject:[NSString stringWithFormat:@"%.2f", d]];
        }
        d += 1;
    }
    
    [self showPickerView:sender withPickerList:pickerList];

}

-(void)contactLensbc:(id)sender
{
    NSArray *values = [NSArray arrayWithObjects:@"8.5",@"8.6",@"8.8", nil];
    [self showPickerView:sender withPickerList:values];
    
}


-(void)contactLensDia:(id)sender
{
    NSMutableArray *pickerList = [NSMutableArray new];
    for(double d = 13.8; d<=14.5;)
    {
        [pickerList addObject:[NSString stringWithFormat:@"%.1f", d]];
        d += 0.1;
    }
    [self showPickerView:sender withPickerList:pickerList];

}


-(void)contactLensSphere:(id)sender
{
    NSMutableArray *pickerList = [NSMutableArray new];
    for(int d = 10; d<200;)
    {
        [pickerList addObject:[NSString stringWithFormat:@"%d", d]];
        d += 10;
    }
    [self showPickerView:sender withPickerList:pickerList];
    
}

-(void)contactLensCylinder:(id)sender
{
    NSMutableArray *pickerList = [NSMutableArray new];
    for(double d = -2.25; d< -0.75;)
    {
        [pickerList addObject:[NSString stringWithFormat:@"%.2f", d]];
        d += 0.5;
    }
    [self showPickerView:sender withPickerList:pickerList];
    
}

-(void)showWarning{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@""
                                                                    message:@""
                                                             preferredStyle:UIAlertControllerStyleAlert];;
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alertC addAction:defaultAction];
    [self presentViewController:alertC animated:NO completion:nil];
}

-(void)showMessageForUpdate{
    __weak typeof (self)weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save Changes" message:@"Click save to update changes to this prescription.You can click cancel to continue to make changes." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"SAVE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf saveAndProceed];
        [self.navigationController popToRootViewControllerAnimated:true];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       // [self.navigationController popViewControllerAnimated:true];
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:^{
        
    }];
}


-(IBAction)savePrescriptionTapped:(id)sender
{
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *nameTF = [cell viewWithTag:NAME_TAG];
    [nameTF resignFirstResponder];

    
    UITextField *doctorNameTF = [cell viewWithTag:2];
    [doctorNameTF resignFirstResponder];
    NSString *trimmedName = [self.prescription.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(trimmedName.length <= 0)
    {
        [self showPopupWithContent:@"Please enter Prescription name"];
       // nameTF.has
      //  [nameTF seter]
        return;
    }
    self.prescription.date = [(UITextField*)[cell viewWithTag:3] text];
    
    if (!self.isRegularLensCategorySelected&&!self.isContactLensCategorySelected)
    {
        LensCategoryTableViewCell *categoryCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        [categoryCell.lensCategoryLabel setTextColor:[UIColor redColor]];
        [categoryCell layoutIfNeeded];
        return;
    }
    
    if (self.isContactLensCategorySelected)
    {
        if (![[self.contactLensDetails objectForKey:@"contactType"] length])
        {
            [self showPopupWithContent:@"select contact lens type"];
            return;
        }
        if (![[[self.contactLensDetails valueForKey:@"power"] valueForKey:@"os"] length]||![[[self.contactLensDetails valueForKey:@"power"] valueForKey:@"od"] length])
        {
            [self showPopupWithContent:@"complete your power prescription"];
            return;
        }
        
        if (![[[self.contactLensDetails valueForKey:@"bc"] valueForKey:@"os"] length]||![[[self.contactLensDetails valueForKey:@"bc"] valueForKey:@"od"] length])
        {
            [self showPopupWithContent:@"complete your bc prescription"];
            return;
        }
        
        if (![[[self.contactLensDetails valueForKey:@"dia"] valueForKey:@"os"] length]||![[[self.contactLensDetails valueForKey:@"dia"] valueForKey:@"od"] length])
        {
            [self showPopupWithContent:@"complete your dia prescription"];
            return;
        }
        if ([[self.contactLensDetails objectForKey:@"contactType"] isEqualToString:@"Bifocal Contacts"])
        {
            if (![[[self.contactLensDetails valueForKey:@"add"] valueForKey:@"os"] length]||![[[self.contactLensDetails valueForKey:@"add"] valueForKey:@"od"] length])
            {
                [self showPopupWithContent:@"select Add lens type"];
                return;
            }
        }
        if ([[self.contactLensDetails objectForKey:@"contactType"] isEqualToString:@"Astigmatism"])
        {
            if (![[[self.contactLensDetails valueForKey:@"cylinder"] valueForKey:@"os"] length]||![[[self.contactLensDetails valueForKey:@"cylinder"] valueForKey:@"od"] length])
            {
                [self showPopupWithContent:@"select cylinder lens type"];
                return;
            }
            if (![[[self.contactLensDetails valueForKey:@"axis"] valueForKey:@"os"] length]||![[[self.contactLensDetails valueForKey:@"axis"] valueForKey:@"od"] length])
            {
                [self showPopupWithContent:@"select axis lens type"];
                return;
            }
        }
    }
    if (self.isRegularLensCategorySelected)
    {
        if (![[self.regularLensDetails valueForKey:@"type"] length])
        {
            [self showPopupWithContent:@"select Prescrption type"];
            return;
        }else if(![[[self.regularLensDetails valueForKey:@"sphere"] valueForKey:@"os"] length]||![[self.regularLensDetails valueForKey:@"sphere"] valueForKey:@"od"])
        {
            [self showPopupWithContent:@"Complete your Sphere prescription"];
            return;
        }else if(![[[self.regularLensDetails valueForKey:@"cylinder"] valueForKey:@"os"] length]||![[[self.regularLensDetails valueForKey:@"cylinder"] valueForKey:@"od"] length]) // //
        {
            [self showPopupWithContent:@"Complete your Cylinder prescription"];
            return;

        }else if(![[[self.regularLensDetails valueForKey:@"axis"] valueForKey:@"os"] length]||![[[self.regularLensDetails valueForKey:@"axis"] valueForKey:@"od"] length])
        {
            [self showPopupWithContent:@"Complete your Axis prescription"];
            return;

        }else if(![[[self.regularLensDetails valueForKey:@"add"] valueForKey:@"os"] length]||![[[self.regularLensDetails valueForKey:@"add"] valueForKey:@"od"] length])
        {
            [self showPopupWithContent:@"Complete your Add prescription"];
            return;
        }
//        else if(self.prismSelectionType == NONE && !self.isDistanceLensSelected )
//        {
//            [self showPopupWithContent:@"select Prism value"];
//            return;
//        }
        else if(!self.isSinglePDSelected && !self.isDualPDSelected)
        {
            if(!self.isPDIgnored)
            {
                NSString *text = @"Do you have pd or pupillary distance values on your prescription? can't find it! that's fine click on Save your Prescription.";
                
                [self showMessagePrompt:text withTitle:@"Pupillary distance" withButtonTitles:@[@"YES, FOUND THAT!", @"CAN\"T FIND IT!"] completionBlock:^(NSInteger index)
                 {
                     if(index == 0)
                     {
                         
                     }
                     else
                     {
                         self.isPDIgnored = true;
                     }
                 }
                 ];
                return;
            }
        }else if(self.isSinglePDSelected){
            if (![[[self.regularLensDetails valueForKey:@"pd"] valueForKey:@"singlePd"] length]){
                [self showPopupWithContent:@"select PD value"];
                return;
            }
            
        }else if(self.isDualPDSelected){
            if ((![[[[self.regularLensDetails valueForKey:@"pd"] valueForKey:@"dualPd"] valueForKey:@"os"] length])||
                (![[[[self.regularLensDetails valueForKey:@"pd"] valueForKey:@"dualPd"] valueForKey:@"od"] length]))
            {
                [self showPopupWithContent:@"select PD value"];
                return;
            }
        }
        else if((self.prismSelectionType == YES_SELECTED) && !self.isDistanceLensSelected){
            if (![[[self.regularLensDetails valueForKey:@"prismValues"] valueForKey:@"prismOs"] length]||![[[self.regularLensDetails valueForKey:@"prismValues"] valueForKey:@"prismOd"] length]){
                [self showPopupWithContent:@"Complete your Prism prescription"];
                return;
            }
            if (![[[self.regularLensDetails valueForKey:@"base"] valueForKey:@"os"] length]||![[[self.regularLensDetails valueForKey:@"base"] valueForKey:@"od"] length]){
                [self showPopupWithContent:@"Complete your Base prescription"];
                return;
            }
        }
    }
    if (self.editableDetails){
        [self showMessageForUpdate];
        return;
    }
    else
    {
        [self saveAndProceed];
    }

}

-(void)saveAndProceed
{
 
    if(self.isContactLensCategorySelected)
    {
        if ([self.contactLensDetails allKeys].count > 0){
            [self.neededConfiguration setValue:self.contactLensDetails forKey:@"prescriptionContactLens"];
        }
        [self.neededConfiguration setValue:[NSNumber numberWithBool:true] forKey:@"contactLens"];

    }
    else
    {
        [self.neededConfiguration setValue:[NSNumber numberWithBool:false] forKey:@"contactLens"];
    }
    
    if(self.isRegularLensCategorySelected)
    {
        if ([self.regularLensDetails allKeys].count > 0){
            [self.neededConfiguration setValue:self.regularLensDetails forKey:@"prescriptionGlasses"];
        }
        [self.neededConfiguration setValue:[NSNumber numberWithBool:true] forKey:@"regularLens"];

    }else{
        [self.neededConfiguration setValue:[NSNumber numberWithBool:false] forKey:@"regularLens"];
    }
    
    if (([self.personalDetails allKeys].count > 0) ){
        [self.neededConfiguration setValue:self.personalDetails forKey:@"prescriptionInfo"];
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.neededConfiguration
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonString:%@",jsonString);
    
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", decodedString); // foo

    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    NSLog(@"dictionary:%@",dictionary);
    [[PrescriptionManager shareInstance] addPrescription:self.prescription details:self.neededConfiguration oldName:self.oldName];
    
    if(self.editableDetails)
    {
        [FIRAnalytics logEventWithName:@"BTN_CLICK_UPDATE_PRESP"
                            parameters:@{
                                         kFIRParameterItemID:@"BTN_CLICK_UPDATE_PRESP",
                                         kFIRParameterItemName:@"Update Prescription",
                                         kFIRParameterContentType:@"text"
                                         }];

    }
    else
    {
        [FIRAnalytics logEventWithName:@"BTN_CLICK_SAVE_PRESP"
                            parameters:@{
                                         kFIRParameterItemID:@"BTN_CLICK_SAVE_PRESP",
                                         kFIRParameterItemName:@"Save Prescription",
                                         kFIRParameterContentType:@"text"
                                         }];

    }
    
    [self.view makeToast:@"Congratulations you have successfully created the prescription." duration:0.5 position:CSToastPositionBottom title:nil image:nil style:nil completion:^(BOOL didTap) {
        [self dismiss:nil];

    }];
    
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == NAME_TAG)//name
    {
        self.prescription.name = textField.text;
        if (self.editableDetails){
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *oldDict = [self.editableDetails valueForKey:@"prescriptionInfo"];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setValue:textField.text forKey:@"name"];
            [self.neededConfiguration setValue:newDict forKey:@"prescriptionInfo"];
            [self.editableDetails setValue:newDict forKey:@"prescriptionInfo"];
            self.personalDetails = newDict;
        }else{
            [self.personalDetails setValue:textField.text forKey:@"name"];
            [[self.neededConfiguration objectForKey:@"prescriptionInfo"] setObject:textField.text forKey:@"name"];
        }
    }
    else if(textField.tag == 2)//doctor name
    {
        self.prescription.doctorName = textField.text;
        if (self.editableDetails){
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *oldDict = [self.editableDetails valueForKey:@"prescriptionInfo"];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setValue:textField.text forKey:@"doctorName"];
            [self.editableDetails setValue:newDict forKey:@"prescriptionInfo"];
            [self.neededConfiguration setValue:newDict forKey:@"prescriptionInfo"];
            self.personalDetails = newDict;
        }else{
            [self.personalDetails setValue:textField.text forKey:@"doctorName"];
            [[self.neededConfiguration objectForKey:@"prescriptionInfo"] setObject:textField.text forKey:@"doctorName"];
        }
    }
}


-(void)selectButtonTapped:(id)sender{
    UIButton *btn = (UIButton*)sender;
    [self contactLensTypePickerTapped:sender];
    if (btn.tag == 55)
    {
        [self prescriptionTypePickerTapped:sender];
    }
}

- (void)sphereHelpTapped:(id)sender
{
    [self showPopupForSphere:sender];
}
- (void)cylinderHelpTapped:(id)sender
{
    [self showPopupForCylinder:sender];
}

- (void)rightSphereTapped:(id)sender
{
    [self spherePickerTapped:sender];
}
- (void)leftSphereTapped:(id)sender
{
    [self spherePickerTapped:sender];

}
- (void)regularLensRightCylinderTapped:(id)sender
{
    [self regularLensCylinderPickerTapped:sender];
}
- (void)regularLensLeftCylinderTapped:(id)sender
{
    [self regularLensCylinderPickerTapped:sender];

}

- (void)axisHelpTapped:(id)sender
{
    [self showPopupForAxis:sender];
}
- (void)addHelpTapped:(id)sender
{
    if (self.isAstigmatismSelected)
    {
        [self showPopupForCylinder:sender];
    }else{
        [self showPopupForAdd:sender];
    }
    
}
- (void)rightAxisTapped:(id)sender
{
    [self axisPickerTapped:sender];
}
- (void)leftAxisTapped:(id)sender
{
    [self axisPickerTapped:sender];
}

-(void)regularLensAddTapped:(id)sender
{
    [self regularlensAddPickerTapped:sender];
}


- (void)powerHelp:(id)sender
{
    [self showPopupForPower:sender];
}

- (void)bcHelp:(id)sender
{
    [self showPopupForBC:sender];
}
- (void)diaHelp:(id)sender
{
    [self showPopupForDia:sender];
}
- (void)powerTapped:(id)sender
{
    [self contactLensPower:sender];
}
- (void)bcTapped:(id)sender
{
    [self contactLensbc:sender];
    
}
- (void)diaTapped:(id)sender
{
    [self contactLensDia:sender];
    
}
-(void)contactLensAddHelpTapped:(id)sender
{
    [self addHelpTapped:sender];
}
-(void)contactLensAxisHelpTapped:(id)sender
{
    [self axisHelpTapped:sender];
}
- (void)addTapped:(id)sender
{
    [self addPickerTapped:sender];
    
}
- (void)cylinderTapped:(id)sender
{
    [self cylinderPickerTapped:sender];
}

- (void)contactLensAddTapped:(id)sender
{
    if (self.isAstigmatismSelected)
    {
        [self cylinderPickerTapped:sender];
    }
    else{
        [self addPickerTapped:sender];
    }
}


- (void)prismRightTapped:(id)sender
{
    [self prismPickerTapped:sender];
}
- (void)prismLeftTapped:(id)sender
{
    [self prismPickerTapped:sender];

}
- (void)prismBaseRightTapped:(id)sender
{
    [self basePickerTapped:sender];
}
- (void)prismBaseLeftTapped:(id)sender
{
    [self basePickerTapped:sender];
    
}

- (void)prismHelpTapped:(id)sender
{
    [self showPopupForPrism:sender];
}

- (void)rightPDSelected:(id)sender
{
    [self pdPickerTapped:sender];
}
- (void)leftPDSelected:(id)sender
{
     [self pdPickerTapped:sender];
}

-(void)pupillaryHelpTapped:(id)sender
{
    [self showPopupWithContent:@"PD is the distnace between your pupils. Usually, it ranges from 57 to 65 mm. Its is highly recommended to get your PD from your optometrist if you have a high power or if you are going to order bifocal, progressive or computer lenses."];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;                                               // any offset changes
{
    [self removePickerView];
    [self removeDatePickerView];
}


@end
