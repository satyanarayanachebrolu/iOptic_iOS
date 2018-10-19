//
//  NotesTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesDescLbl;
@property (weak, nonatomic) IBOutlet UIView *containerForLabels;

@end
