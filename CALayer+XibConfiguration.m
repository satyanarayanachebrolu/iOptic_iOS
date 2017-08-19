//
//  CALayer+XibConfiguration_h.m
//  iOptic
//
//  Created by Santhosh Kumar on 01/08/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer(XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
