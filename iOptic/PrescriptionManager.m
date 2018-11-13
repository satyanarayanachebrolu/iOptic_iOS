//
//  MenuItem.m
//  XLPagerTabStrip
//
//  Created by Satyanarayana Chebrolu on 9/10/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

#import "PrescriptionManager.h"
#import <FirebaseFirestore/FIRFirestore.h>
#import "iOptic-Swift.h"

@class iOpticEncryption;

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
                [self pushToFireStore:mutDict];
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

    //NSDictionary *configurationDetails = [NSDictionary dictionaryWithObjectsAndKeys:configuration,prescription.name, nil];
    NSMutableArray *prescriptionsSaved = [[[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"] mutableCopy];
    NSString *name = oldName ? oldName :prescription.name;
    
    
    NSMutableArray *prescriptions;

    if (prescriptionsSaved == nil){
        prescriptions = [NSMutableArray arrayWithObject:configuration];
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
            [prescriptionsSaved insertObject:configuration atIndex:indexOfExistingObj];
        }else{
            [prescriptionsSaved addObject:configuration];
        }
        prescriptions = prescriptionsSaved;
        [[NSUserDefaults standardUserDefaults] setObject:prescriptionsSaved forKey:@"prescriptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self pushToFireStore:configuration];
    
//    NSString *userDocumentID = [self getUserDocumentID];
//    NSString *prescriptionsPath = [NSString stringWithFormat:@"/users/%@/Prescriptions", userDocumentID];
//
//
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:configurationDetails
//                                                       options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//
//    char bytes[17];
//    bytes[16] = '\0';
//    for(int i = 0; i < 16; i++)
//    {
//        bytes[i] = i+1;
//    }
//    NSData *ivData = [NSData dataWithBytes:bytes length:16];
//    NSData *keyData = [iOpticEncryption symetricKeyWithPassword:@"123123" salt:@"kjasdnkjnasdakjsdkjasndk" rounds:1000];
//
//    NSDictionary *encryptedDict = [iOpticEncryption aesEncryptWithInput:jsonString iv:ivData key:keyData];
//
//    NSMutableDictionary *encryptedPrescriptionDict = [NSMutableDictionary new];
//    encryptedPrescriptionDict[prescription.prespId] = encryptedDict;
//
////    NSData *decryptedData = [iOpticEncryption aesDecryptWithEncrypted:encryptedDict[@"EncryptionData"] iv:ivData key:keyData];
////
////    NSString *decryptedString = [NSString stringWithCString:[decryptedData bytes] encoding:NSUTF8StringEncoding];
////
////    NSLog(@"decryptedString:%@", decryptedString);
//
//    FIRCollectionReference *fireStoreCollection = [[FIRFirestore firestore] collectionWithPath:prescriptionsPath];
//    FIRDocumentReference *docRef = [fireStoreCollection addDocumentWithData:encryptedPrescriptionDict];
//    NSLog(@"docRef ID:%@", [docRef documentID]);
}

-(NSArray<Prescription*>*)prescriptionsList
{
    [_prescriptionsList removeAllObjects];
    NSMutableArray *prescriptions = [[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"];
    if (prescriptions.count > 0){
        for (NSDictionary *prescription in prescriptions){
            NSDictionary *personalDetails = [prescription valueForKey:@"prescriptionInfo"];
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

-(BOOL)pushToFireStore:(NSDictionary*)dict
{
    NSString *userDocumentID = [self getUserDocumentID];
    NSString *prescriptionsPath = [NSString stringWithFormat:@"/users/%@/Prescriptions", userDocumentID];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    char bytes[17];
    bytes[16] = '\0';
    for(int i = 0; i < 16; i++)
    {
        bytes[i] = i+1;
    }
    NSData *ivData = [NSData dataWithBytes:bytes length:16];
    NSData *keyData = [iOpticEncryption symetricKeyWithPassword:@"123123" salt:@"kjasdnkjnasdakjsdkjasndk" rounds:1000];
    
    NSDictionary *encryptedDict = [iOpticEncryption aesEncryptWithInput:jsonString iv:ivData key:keyData];
    
    NSMutableDictionary *encryptedPrescriptionDict = [NSMutableDictionary new];
    
    NSMutableDictionary *prescriptionInfo = dict[@"prescriptionInfo"];
    encryptedPrescriptionDict[prescriptionInfo[@"prespId"]] = encryptedDict[@"EncryptionData"];
    
    FIRCollectionReference *fireStoreCollection = [[FIRFirestore firestore] collectionWithPath:prescriptionsPath];
    FIRDocumentReference *docRef = [fireStoreCollection addDocumentWithData:encryptedPrescriptionDict];
    NSLog(@"docRef ID:%@", [docRef documentID]);


    return YES;
}


@end
