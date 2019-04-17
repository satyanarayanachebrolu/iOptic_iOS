//
//  MenuItem.h
//  XLPagerTabStrip
//
//  Created by Satyanarayana Chebrolu on 9/10/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Prescription.h"

typedef void (^PrescriptionListCompletionBlock)(NSArray *prescriptionsList);


@interface PrescriptionManager : NSObject
{
}

+(instancetype)shareInstance;
-(void)setupUserProfile;
-(void)addPrescription:(Prescription *)prescription details:(NSDictionary*)configuration oldName:(NSString*)oldName;
-(void)editPrescription:(Prescription *)prescription details:(NSDictionary*)configuration;

-(void)getPrescriptionsListWithCompletion:(PrescriptionListCompletionBlock)completionHandler;
-(NSArray<Prescription*>*)prescriptionsList;
-(NSDictionary*)prescriptionForId:(NSString*)pId;
-(void)deletePrescriptionForId:(NSString*)pId;
@end
