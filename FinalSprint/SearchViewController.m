//
//  SearchViewController.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/26/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "SearchViewController.h"
#import "MovieTableViewCell.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Provider.h"
#import "Movie+CoreDataClass.h"
#import "DetailViewController.h"

@interface SearchViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) Provider *provider;
@property(nonatomic,strong) NSEntityDescription *movieEntity;
@property(nonatomic,strong) NSString *movieUrl;
@property(nonatomic,strong) NSArray *genreArray;
@property(nonatomic,strong) NSDictionary *genreDictionary;
@property(nonatomic,strong) NSArray *movieArray;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSLog(@"%@", [searchBar text]);
    
}
- (void) dismissKeyboard
{
    [self.searchBar resignFirstResponder];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableViewCell *cell = (MovieTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    return cell;
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
