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

-(id)initWithArray:(NSArray *)array withBlock:(void(^)()) block
{
    self=[super init];
    if(self)
    {
        self.dataArray=array;
        self.myBlock=block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // add touch recogniser to dismiss this controller
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMe)];
    //[self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissMe {
    
    NSLog(@"Popover was dismissed with internal tap");
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItem=[self.dataArray objectAtIndex:indexPath.row];
    self.myBlock(self.selectedItem);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hideControllerButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
