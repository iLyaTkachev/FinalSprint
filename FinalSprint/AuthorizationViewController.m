//
//  AuthorizationViewController.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/29/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "AuthorizationViewController.h"

@interface AuthorizationViewController ()

@end

@implementation AuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationController *globalNC = [[UINavigationController alloc]initWithRootViewController:self];
    UIApplication.sharedApplication.delegate.window.rootViewController = globalNC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)skipLoginClicked:(id)sender {
    UITabBarController *tabBarContr = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarContr"];
    [self.navigationController pushViewController:tabBarContr animated:YES];
    [self.navigationController setNavigationBarHidden: YES];
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
