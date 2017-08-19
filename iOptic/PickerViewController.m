//
//  PickerViewController.m
//  XLPagerTabStrip
//
//  Created by Satyanarayana Chebrolu on 9/13/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closePickerController:(id)sender
{
    [self.delegate pickerViewController:self didSelectItem:self.pickerList[[self.pickerView selectedRowInComponent:0]]];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerList.count;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerList[row];
}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    [self.delegate pickerViewController:self didSelectItem:self.pickerList[row]];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
