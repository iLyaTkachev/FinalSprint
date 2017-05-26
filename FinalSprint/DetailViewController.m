//
//  DetailViewController.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/22/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "DetailViewController.h"
#import "Movie+CoreDataProperties.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *objectTitle;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"details is loaded");
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)configureVCwithObject:(NSObject *)object withObjectType:(NSString *)type{
    if ([type isEqualToString:@"Movie"]) {
        self.objectTitle.text=[object valueForKey:@"title"];
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
