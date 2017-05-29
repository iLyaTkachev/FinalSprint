//
//  PopViewController.m
//  Popovers
//
//  Created by Jay Versluis on 17/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "PopViewController.h"
#import "PopTableViewCell.h"

@interface PopViewController ()

@end

@implementation PopViewController

@synthesize dataArray=dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // add touch recogniser to dismiss this controller
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES];
}
- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PopTableViewCell *cell = (PopTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *text = [dataArray objectAtIndex:indexPath.row];
    cell.genre.text = text;
    if ([text isEqualToString:self.selectedItem]) {
        cell.genre.textColor=[UIColor blueColor];
    }
    else{
        cell.genre.textColor=[UIColor blackColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItem=[self.dataArray objectAtIndex:indexPath.row];
    self.myBlock(self.selectedItem);
}


@end
