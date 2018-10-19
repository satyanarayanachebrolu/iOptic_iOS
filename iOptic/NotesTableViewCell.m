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
    
    self.notesDescLbl.text = @"enter any notes here (optional)";
    self.notesDescLbl.textColor = [UIColor lightGrayColor]; //optional
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"enter any notes here (optional)"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"enter any notes here (optional)";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    else
    {
        [self.delegate notesText:self.notesDescLbl.text];
    }
    [textView resignFirstResponder];
}

@end
