//
//  NotesTableViewCell.m
//  iOptic
//
//  Created by Santhosh on 04/06/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

#import "NotesTableViewCell.h"
#import "iOptic-Swift.h"

@implementation NotesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.notesDescLbl.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [self.delegate notesBegin];
    if([text isEqualToString:@"\n"]) {
        [self.delegate notesText:self.notesDescLbl.text];
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
@end
