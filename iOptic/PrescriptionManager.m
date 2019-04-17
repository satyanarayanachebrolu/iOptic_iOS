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
    
    [self setupUserProfile];
    
    return self;
}

-(void)setupUserProfile
{
    FIRUser *user = [FIRAuth auth].currentUser;
    if(user)
    {
        NSString *path = [NSString stringWithFormat:@"users"];
        FIRCollectionReference *fireStoreCollection = [[FIRFirestore firestore] collectionWithPath:path];
        FIRDocumentReference *docRef = [fireStoreCollection documentWithPath:[user uid]];
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[@"emailAddress"] = user.email;
        dict[@"name"] = user.displayName;
        dict[@"profileUrl"] = [user.photoURL absoluteString];
        NSMutableDictionary *profileDict = [NSMutableDictionary new];
        profileDict[@"userProfile"] = dict;
        [docRef setData:profileDict];
    }
}

-(void)addPrescription:(Prescription *)prescription details:(NSDictionary*)configuration oldName:(NSString*)oldName
{
    prescription.prespId = [NSString stringWithFormat:@"%ld", time(NULL)];
    NSMutableDictionary *prescriptionInfo = configuration[@"prescriptionInfo"];
    prescriptionInfo[@"prespId"] = prescription.prespId;
    NSDictionary *encryptedDict = [self pushToFireStore:configuration];
    
    NSMutableDictionary *prescriptionsDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"] mutableCopy];
    if(!prescriptionsDict)
    {
        prescriptionsDict = [NSMutableDictionary new];
    }
    [prescriptionsDict setObject:encryptedDict forKey:prescription.prespId];
    [[NSUserDefaults standardUserDefaults] setObject:prescriptionsDict forKey:@"prescriptions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)editPrescription:(Prescription *)prescription details:(NSDictionary*)configuration
{
    NSDictionary *encryptedDict = [self pushToFireStore:configuration];
    
    NSMutableDictionary *prescriptionsDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"] mutableCopy];
    if(!prescriptionsDict)
    {
        prescriptionsDict = [NSMutableDictionary new];
    }
    [prescriptionsDict setObject:encryptedDict forKey:prescription.prespId];
    [[NSUserDefaults standardUserDefaults] setObject:prescriptionsDict forKey:@"prescriptions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSArray<Prescription*>*)prescriptionsList
{
    [_prescriptionsList removeAllObjects];
    NSMutableDictionary *prescriptions = [[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"];

    for (NSString *prescriptionId in prescriptions){
        NSDictionary *dict = [self prescriptionForId:prescriptionId];
        NSLog(@"dict %@", dict);
        NSDictionary *pDict = dict[@"prescriptionInfo"];
        Prescription *p = [[Prescription alloc] init];
        p.name = [pDict valueForKey:@"name"];
        p.doctorName = [pDict valueForKey:@"doctorName"];
        p.date = [pDict valueForKey:@"date"];
        p.prespId = [pDict valueForKey:@"prespId"];
        [_prescriptionsList addObject:p];
    }

    return _prescriptionsList;
}

-(void)getPrescriptionsListWithCompletion:(PrescriptionListCompletionBlock)completionHandler
{
    NSMutableDictionary *prescriptions = [[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"];

    FIRUser *user = [FIRAuth auth].currentUser;
    if(user)
    {
        if(!prescriptions)
        {
            FIRUser *user = [FIRAuth auth].currentUser;
            NSString *path = [NSString stringWithFormat:@"users/%@/Prescriptions",[user uid]];
            
            prescriptions = [NSMutableDictionary new];
            NSMutableDictionary *decryptedPrescriptionsDict = [NSMutableDictionary new];
            
            [[[FIRFirestore firestore] collectionWithPath:path]
             getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
                 if (error != nil) {
                     NSLog(@"Error getting documents: %@", error);
                 } else {
                     for (FIRDocumentSnapshot *document in snapshot.documents) {
                         NSLog(@"%@ => %@", document.documentID, document.data);
                         NSDictionary *encryptedDict = document.data;
                         NSString *encodedString = encryptedDict[@"encPresppojo"];
                         NSDictionary *decryptedDict = [self decryptedPrescriptionFromEncodedString:encodedString];
                         NSDictionary *pDict = decryptedDict[@"prescriptionInfo"];
                         decryptedPrescriptionsDict[[pDict valueForKey:@"prespId"]] = decryptedDict;
                         prescriptions[[pDict valueForKey:@"prespId"]] = encryptedDict;
                         
                         Prescription *p = [[Prescription alloc] init];
                         p.name = [pDict valueForKey:@"name"];
                         p.doctorName = [pDict valueForKey:@"doctorName"];
                         p.date = [pDict valueForKey:@"date"];
                         p.prespId = [pDict valueForKey:@"prespId"];
                         [_prescriptionsList addObject:p];
                     }
                 }
                 
                 [[NSUserDefaults standardUserDefaults] setObject:prescriptions forKey:@"prescriptions"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 completionHandler(_prescriptionsList);
             }];

        }
        else
        {
            completionHandler([self prescriptionsList]);
        }
    }
    else
    {
        completionHandler([self prescriptionsList]);
    }

}


-(void)deletePrescriptionForId:(NSString*)pId
{
    NSMutableDictionary *prescriptionsDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"] mutableCopy];
    [prescriptionsDict removeObjectForKey:pId];
    [[NSUserDefaults standardUserDefaults] setObject:prescriptionsDict forKey:@"prescriptions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString *path = [NSString stringWithFormat:@"users/%@/Prescriptions/%@",[user uid],pId];
    FIRDocumentReference* docRef = [[FIRFirestore firestore] documentWithPath:path];
    [docRef deleteDocument];
}

-(NSDictionary*)decryptedPrescriptionFromEncodedString:(NSString*)encodedString
{
    char bytes[17];
    bytes[16] = '\0';
    for(int i = 0; i < 16; i++)
    {
        bytes[i] = i+1;
    }
    NSData *ivData = [NSData dataWithBytes:bytes length:16];

    NSData *data = [[NSData alloc] initWithBase64EncodedString:encodedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSData *keyData = [iOpticEncryption symetricKeyWithPassword:@"123123" salt:@"kjasdnkjnasdakjsdkjasndk" rounds:1000];
    
    NSData *decryptedData = [iOpticEncryption aesDecryptWithEncrypted:data iv:ivData key:keyData];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:decryptedData options:0 error:&error];
    return dict;
}


-(NSDictionary*)prescriptionForId:(NSString*)pId
{
    NSMutableDictionary *prescriptions = [[NSUserDefaults standardUserDefaults] objectForKey:@"prescriptions"];
    NSDictionary *encryptedDict = [prescriptions valueForKey:pId];
    NSString *encodedString = encryptedDict[@"encPresppojo"];
    return [self decryptedPrescriptionFromEncodedString:encodedString];
}

-(NSDictionary *)pushToFireStore:(NSDictionary*)dict
{
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
    NSString *encodedString = [encryptedDict[@"EncryptionData"] base64EncodedStringWithOptions:0];
    encryptedPrescriptionDict[@"encPresppojo"] = encodedString;
    FIRUser *user = [FIRAuth auth].currentUser;
    if(user)
    {
        NSString *path = [NSString stringWithFormat:@"users/%@/Prescriptions",[user uid]];
        FIRCollectionReference *fireStoreCollection = [[FIRFirestore firestore] collectionWithPath:path];
        NSMutableDictionary *prescriptionInfo = dict[@"prescriptionInfo"];
        FIRDocumentReference *docRef = [fireStoreCollection documentWithPath:prescriptionInfo[@"prespId"]];
        [docRef setData:encryptedPrescriptionDict];
    }

    return encryptedPrescriptionDict;
}



@end
