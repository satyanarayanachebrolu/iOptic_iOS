//
//  CALayer+XibConfiguration_h.h
//  iOptic
//
//  Created by Santhosh Kumar on 01/08/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer(XibConfiguration)

// This assigns a CGColor to borderColor.
@property(nonatomic, assign) UIColor* borderUIColor;

@end
