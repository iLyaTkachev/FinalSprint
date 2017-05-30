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
@property (nonatomic,strong) NSMutableDictionary *oldDict;
@end

@implementation PopViewController

@synthesize dataArray=dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // add touch recogniser to dismiss this controller
    self.oldDict = [self.selectedGenreDictionary mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self.delegate settingsChoosedWithResult:self.selectedGenreDictionary];
}
- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self.delegate settingsChoosedWithResult:self.oldDict];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *text = [dataArray objectAtIndex:indexPath.row];
    cell.genre.text = text;
    if ([[self.selectedGenreDictionary objectForKey:text] boolValue]) {
        cell.genre.textColor=[UIColor blueColor];
    }
    else{
        cell.genre.textColor=[UIColor blackColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [self.dataArray objectAtIndex:indexPath.row];
    bool value=[[self.selectedGenreDictionary valueForKey:text] boolValue];
    if (value) {
        [self.selectedGenreDictionary setObject:[NSNumber numberWithBool:NO] forKey:text];
    }
    else if(!value && ![text isEqualToString:@"All"]){
        [self.selectedGenreDictionary setObject:[NSNumber numberWithBool:YES] forKey:text];
        [self.selectedGenreDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"All"];
    }
    else if (!value && [text isEqualToString:@"All"])
    {
        for (NSString *genre in [self.selectedGenreDictionary allKeys]) {
            [self.selectedGenreDictionary setObject:[NSNumber numberWithBool:NO] forKey:genre];
        }
        [self.selectedGenreDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"All"];
        
    }
    [self.myTableView reloadData];
}


@end
