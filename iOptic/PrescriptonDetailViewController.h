//
//  PrescriptonDetailViewController.h
//  iOptic
//
//  Created by Santhosh on 27/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrescriptonDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) NSString *name;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic)  NSMutableDictionary *currentPrescriptionDict;
@property(nonatomic)  NSString *currentPrescriptionJSON;




@end
