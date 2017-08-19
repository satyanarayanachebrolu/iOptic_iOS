//
//  MenuViewController.m
//  XLPagerTabStrip
//
//  Created by Satyanarayana Chebrolu on 9/10/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController()
@property(nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@end

@implementation MenuViewController

-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
//    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y-self.tableView.frame.size.height, self.tableView.frame.size.width, 1);
//
    self.tableHeightConstraint.constant = 1;

    [UIView animateWithDuration:0.5 animations:^{
        
        NSLog(@"in animations");
        
    }completion:^(BOOL finished)
     {
         self.tableHeightConstraint.constant = 186;

     }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"mycell"];
    
    UILabel *label = (UILabel*)[cell viewWithTag:1];
    label.text = self.menuItemList[indexPath.row].title;
    
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:2];
    imageView.image = [UIImage imageNamed:self.menuItemList[indexPath.row].iconName];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate menuViewController:self didSelectMenuItem:self.menuItemList[indexPath.row]];
}

@end
