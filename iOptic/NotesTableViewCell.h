//
//  NotesTableViewCell.h
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotesTableViewCellDelegate <NSObject>

-(void)notesText:(NSString*)notesText;
-(void)notesBegin;


@end

@interface NotesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesDescLbl;
@property(weak) id <NotesTableViewCellDelegate> delegate;


@end
