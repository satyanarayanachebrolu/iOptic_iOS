//
//  MenuItem.m
//  XLPagerTabStrip
//
//  Created by Satyanarayana Chebrolu on 9/10/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

#import "PrescriptionManager.h"
@import Firebase;

@interface PrescriptionManager()
@property(nonatomic) NSMutableArray *prescriptionsList;
@property (strong, nonatomic) FIRDatabaseReference *ref;

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
    self.ref = [[FIRDatabase database] reference];
    NSString *uuid = [self getUserUUID];

    if(!uuid)
    {
        NSString *uuid = [[NSUUID new] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"userUUID"];
        NSMutableArray *prescriptions = [[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"];
        if(prescriptions)
        {
            [[[self.ref child:@"users"] child:uuid]
             setValue:@{@"Prescriptions": prescriptions}];
        }
    }

    return self;
}

-(NSString*)getUserUUID
{
    NSString *userUUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userUUID"];
    return userUUID;
}

-(void)addPrescription:(Prescription *)prescription details:(NSDictionary*)configuration oldName:(NSString*)oldName
{
    NSDictionary *configurationDetails = [NSDictionary dictionaryWithObjectsAndKeys:configuration,prescription.name, nil];
    NSMutableArray *prescriptionsSaved = [[[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"] mutableCopy];
    NSString *name = oldName ? oldName :prescription.name;
    
    
    NSMutableArray *prescriptions;

    if (prescriptionsSaved == nil){
        prescriptions = [NSMutableArray arrayWithObject:configurationDetails];
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
        prescriptions = prescriptionsSaved;
        [[NSUserDefaults standardUserDefaults] setObject:prescriptionsSaved forKey:@"prescriptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *uuid = [self getUserUUID];
    [[[self.ref child:@"users"] child:uuid]
     setValue:@{@"Prescriptions": prescriptions}];
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
    }

    return _prescriptionsList;
}


@end
