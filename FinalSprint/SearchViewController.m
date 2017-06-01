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
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic,strong) Provider *provider;
@property(nonatomic,strong) NSEntityDescription *movieEntity;
@property(nonatomic,strong) NSString *movieUrl;
@property(nonatomic,strong) NSMutableArray *genreArray;
@property(nonatomic,strong) NSDictionary *genreDictionary;
@property(nonatomic,strong) NSArray *movieArray;
@property(nonatomic,strong) UIImage *noImage;
@end

@implementation SearchViewController

int pageCount;
int oldPageCount;
bool downloadFlag;
bool downloadingError;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)initElements
{
    self.provider = [[Provider alloc]init];
    pageCount = 1;
    downloadFlag = true;
    downloadingError = false;
    self.noImage = [UIImage imageNamed:@"no_image.png"];
    self.genreDictionary = [self.provider getGenresDictionary];
    NSMutableArray *arr = [NSMutableArray arrayWithObject:@"All"];
    [arr addObjectsFromArray:self.genreDictionary.allValues];
    self.genreArray = arr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSLog(@"%@", [searchBar text]);
    pageCount=1;
    self.movieArray = [[NSMutableArray alloc]init];
    self.movieUrl = [NSString stringWithFormat: @"%@%@%@%@%@%d%@",movieSearch1,apiV3Key,movieSearch2,[searchBar text],movieSearch3,pageCount,movieSearch4];
    [self downloadMoviesWithTableReloading:YES];
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

-(void)downloadMoviesWithTableReloading:(bool)reload
{
    downloadFlag = false;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //NSString *url=[NSString stringWithFormat: @"%@=%d",self.movieUrl,pageCount];
        [self.provider getObjectsFromURL:self.movieUrl forEntity:nil withBlock:^(NSArray *arr,NSError *error)
         {
             if (error==nil) {
                 [self.movieArray arrayByAddingObjectsFromArray:arr];
                 downloadingError=false;
                 pageCount++;
             } else {
                 NSLog(@"Updating error: %@",error.description);
                 downloadingError=true;
                 pageCount=oldPageCount;
             }
             downloadFlag=true;
             if (reload) {
                 [self.myTableView reloadData];
             }
         }];
    });
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
