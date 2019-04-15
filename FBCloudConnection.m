//
//  FBCloudConnection.m
//  iOptic
//
//  Created by Satyanarayana Chebrolu on 11/04/19.
//  Copyright © 2019 mycompany. All rights reserved.
//

#import "FBCloudConnection.h"
#import <FirebaseFirestore/FIRFirestore.h>
@import Firebase;


@interface FBCloudConnection()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end


@implementation FBCloudConnection

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
    self.ref = [[FIRDatabase database] reference];
    return self;
}


-(void)setupUserProfile
{
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString *path = [NSString stringWithFormat:@"users/%@", [user uid]];
    FIRCollectionReference *fireStoreCollection = [[FIRFirestore firestore] collectionWithPath:path];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"emailAddress"] = user.email;
    dict[@"name"] = user.displayName;
    dict[@"profileUrl"] = [user.photoURL absoluteString];
    NSMutableDictionary *profileDict = [NSMutableDictionary new];
    profileDict[@"userProfile"] = dict;
    FIRDocumentReference *docRef = [fireStoreCollection addDocumentWithData:profileDict];
}

@end
