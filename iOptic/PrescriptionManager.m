//
//  MenuItem.m
//  XLPagerTabStrip
//
//  Created by Satyanarayana Chebrolu on 9/10/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

#import "PrescriptionManager.h"
#import <FirebaseFirestore/FIRFirestore.h>

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
    
    NSString *userDocumentID = [self getUserDocumentID];

    if(!userDocumentID)
    {
        FIRCollectionReference *fireStoreCollection = [[FIRFirestore firestore] collectionWithPath:@"users"];
        NSMutableDictionary *dict = [NSMutableDictionary new];
        FIRUser *user = [FIRAuth auth].currentUser;

        dict[@"emailAddress"] = user.email;
        dict[@"name"] = user.displayName;
        dict[@"profileUrl"] = user.photoURL;
        NSMutableDictionary *profileDict = [NSMutableDictionary new];
        profileDict[@"userProfile"] = dict;
        FIRDocumentReference *docRef = [fireStoreCollection addDocumentWithData:profileDict];
        if(docRef)
        {
            [[NSUserDefaults standardUserDefaults] setObject:docRef.documentID forKey:@"userDocumentID"];
            NSString *prescriptionsPath = [NSString stringWithFormat:@"/users/%@/Prescriptions", docRef.documentID];
            FIRCollectionReference *fireStoreCollection = [[FIRFirestore firestore] collectionWithPath:prescriptionsPath];

            NSMutableArray *prescriptions = [[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"];

            NSMutableArray *updatedPrescriptions = [NSMutableArray new];
            for (NSDictionary *dict in prescriptions) {
                NSMutableDictionary *mutDict = [dict mutableCopy];
                NSMutableDictionary *prescriptionInfo = mutDict[@"prescriptionInfo"];
                if(!prescriptionInfo[@"prespId"])
                {
                    prescriptionInfo[@"prespId"] = [NSString stringWithFormat:@"%ld", time(NULL)];
                }
                mutDict[@"prescriptionInfo"] = prescriptionInfo;
                FIRDocumentReference *docRef = [fireStoreCollection addDocumentWithData:mutDict];
                NSLog(@"docRef ID:%@", [docRef documentID]);
                [updatedPrescriptions addObject:mutDict];
            }
            [[NSUserDefaults standardUserDefaults] setObject:updatedPrescriptions forKey:@"prescriptions"];
        }
    }

    return self;
}

-(NSString*)getUserDocumentID
{
    NSString *userDocumentID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDocumentID"];
    return userDocumentID;
}

-(void)addPrescription:(Prescription *)prescription details:(NSDictionary*)configuration oldName:(NSString*)oldName
{
    prescription.prespId = [NSString stringWithFormat:@"%ld", time(NULL)];
    NSMutableDictionary *prescriptionInfo = configuration[@"prescriptionInfo"];
    prescriptionInfo[@"prespId"] = prescription.prespId;

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
    
    NSString *userDocumentID = [self getUserDocumentID];
    NSString *prescriptionsPath = [NSString stringWithFormat:@"/users/%@/Prescriptions", userDocumentID];
    
    FIRCollectionReference *fireStoreCollection = [[FIRFirestore firestore] collectionWithPath:prescriptionsPath];
    FIRDocumentReference *docRef = [fireStoreCollection addDocumentWithData:configurationDetails];
    NSLog(@"docRef ID:%@", [docRef documentID]);
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
            p.prespId = [personalDetails valueForKey:@"prespId"];
            [_prescriptionsList addObject:p];
        }
    }

    return _prescriptionsList;
}


@end
