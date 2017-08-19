//
//  QRCodeTableViewCelTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 15/08/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "QRCodeTableViewCelTableViewCell.h"
#import <ZXingObjC/ZXingObjC.h>
#import "UIImage+MDQRCode.h"

@implementation QRCodeTableViewCelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateQR:(NSString*)json
{
    self.qrCodeImageView.image = [UIImage mdQRCodeForString:json size:self.qrCodeImageView.bounds.size.width fillColor:[UIColor blackColor]];
    
   /* NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:json
                                  format:kBarcodeFormatQRCode
                                   width:400
                                  height:400
                                   error:&error];
    
    if (result) {
     //   CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        UIImage* uiImage = [[UIImage alloc] initWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];
        self.qrCodeImageView.image = uiImage;
        
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    } else {
        NSString *errorMessage = [error localizedDescription];
        NSLog(@"errorMessage:%@",errorMessage);
    }*/
}

@end
