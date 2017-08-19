//
//  MenuItem.h
//  XLPagerTabStrip
//
//  Created by Satyanarayana Chebrolu on 9/10/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Prescription.h"


@interface PrescriptionManager : NSObject
{
}

+(instancetype)shareInstance;
-(void)addPrescription:(Prescription *)prescription details:(NSDictionary*)configuration oldName:(NSString*)oldName;
-(NSArray<Prescription*>*)prescriptionsList;

@end
