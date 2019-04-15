//
//  FBCloudConnection.h
//  iOptic
//
//  Created by Satyanarayana Chebrolu on 11/04/19.
//  Copyright © 2019 mycompany. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBCloudConnection : NSObject
+(id)sharedInstance;
-(void)setupUserProfile;
@end

NS_ASSUME_NONNULL_END
