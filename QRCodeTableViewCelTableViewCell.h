//
//  QRCodeTableViewCelTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 15/08/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeTableViewCelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

-(void)updateQR:(NSString*)json;
@end
