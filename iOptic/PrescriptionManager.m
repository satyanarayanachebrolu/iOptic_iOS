//
//  MenuItem.m
//  XLPagerTabStrip
//
//  Created by Satyanarayana Chebrolu on 9/10/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

#import "PrescriptionManager.h"

@interface PrescriptionManager()
@property(nonatomic) NSMutableArray *prescriptionsList;
@end

@implementation PrescriptionManager

+(instancetype)shareInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    self.prescriptionsList = [NSMutableArray new];
    return self;
}

-(void)addPrescription:(Prescription *)prescription details:(NSDictionary*)configuration oldName:(NSString*)oldName
{
    // Add it to defaults
    
//    NSDictionary *prescrptionDict = [NSDictionary dictionaryWithObjectsAndKeys:prescription.name,@"name", prescription.doctorName,@"doctorName",prescription.date,@"date", nil];
    NSDictionary *configurationDetails = [NSDictionary dictionaryWithObjectsAndKeys:configuration,prescription.name, nil];
    NSMutableArray *prescriptionsSaved = [[[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"] mutableCopy];
    NSString *name = oldName ? oldName :prescription.name;
    if (prescriptionsSaved == nil){
        NSMutableArray *prescriptions = [NSMutableArray arrayWithObject:configurationDetails];
        [[NSUserDefaults standardUserDefaults] setObject:prescriptions forKey:@"prescriptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        __block NSUInteger indexOfExistingObj = 9999999;
        [prescriptionsSaved enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop)
         {
             if ([item valueForKey:name]){
                 indexOfExistingObj = idx;
                 *stop = YES;
             }
         }];
        
        if (indexOfExistingObj != 9999999){
            [prescriptionsSaved removeObjectAtIndex:indexOfExistingObj];
            [prescriptionsSaved insertObject:configurationDetails atIndex:indexOfExistingObj];
        }else{
            [prescriptionsSaved addObject:configurationDetails];
        }
        [[NSUserDefaults standardUserDefaults] setObject:prescriptionsSaved forKey:@"prescriptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
}

-(NSArray<Prescription*>*)prescriptionsList
{
    [_prescriptionsList removeAllObjects];
    NSMutableArray *prescriptions = [[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"];
    if (prescriptions.count > 0){
        for (NSDictionary *prescription in prescriptions){
            NSDictionary *allValues = [[prescription allValues] objectAtIndex:0];
            NSDictionary *personalDetails = [allValues valueForKey:@"prescriptionInfo"];
            Prescription *p = [[Prescription alloc] init];
            p.name = [personalDetails valueForKey:@"name"];
            p.doctorName = [personalDetails valueForKey:@"doctorName"];
            p.date = [personalDetails valueForKey:@"date"];
            [_prescriptionsList addObject:p];
        }
//        _prescriptionsList = prescriptions;
    }

    
    return _prescriptionsList;
}


@end
