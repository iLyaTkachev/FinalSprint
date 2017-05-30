//
//  MovieViewController.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/9/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieTableViewCell.h"
#import "AppDelegate.h"
#import "Provider.h"
#import "Movie+CoreDataClass.h"
#import "Constants.h"
#import "DetailViewController.h"

@interface MovieViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) Provider *provider;
@property(nonatomic,strong) NSEntityDescription *movieEntity;
@property(nonatomic,strong) NSString *movieUrl;
@property(nonatomic,strong) UIImage *noImage;
@property(nonatomic,strong) NSString *sortingKey;
@property(nonatomic,strong) NSArray *genreArray;
@property(nonatomic,strong) NSDictionary *genreDictionary;
@property(nonatomic,strong) NSMutableDictionary *selectedGenreDictionary;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *genreButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sortButton;

@end


@implementation MovieViewController

int pageCount;
int oldPageCount;
int cellsCount;
bool downloadFlag;
bool downloadingError;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initElements];
}

-(void)initElements
{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.context = delegate.managedObjectContext;
    self.provider = [[Provider alloc]initWithContext:delegate.managedObjectContext];
    pageCount = 1;
    self.movieUrl = [NSString stringWithFormat: @"%@%@&%@&%@",moviesPopular,apiV3Key,lang,page];
    downloadFlag = true;
    downloadingError = false;
    self.movieEntity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:self.context];
    self.noImage = [UIImage imageNamed:@"no_image.png"];
    self.sortingKey = @"popularity";
    self.genreDictionary = [self.provider getGenresDictionary];
    
    NSMutableArray *arr = [NSMutableArray arrayWithObject:@"All"];
    [arr addObjectsFromArray:self.genreDictionary.allValues];
    self.genreArray = arr;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (NSString *genre in self.genreArray) {
        [dict setObject:[NSNumber numberWithBool:NO] forKey:genre];
    }
    [self.selectedGenreDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"All"];
    self.selectedGenreDictionary = dict;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    [self downloadMoviesWithDeleting:true withTableReloading:false];
    
}

- (IBAction)genreClick:(id)sender {
    PopViewController *genreVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Pop"];
    genreVC.delegate=self;
    genreVC.selectedGenreDictionary = self.selectedGenreDictionary;
    genreVC.dataArray = self.genreArray;
    /*genreVC.myBlock=^(NSString *selectedItem)
    {
        self.genreKey=selectedItem;
        self.movieUrl = [NSString stringWithFormat: @"%@%@%@%@%@",moviesByGenres1,[self.genreDictionary allKeysForObject:selectedItem],moviesByGenres2,page];
        NSLog(@"%@",[self.genreDictionary allKeysForObject:selectedItem]);
    };*/
    //sortVC.modalPresentationStyle = UIActionSheetStyleDefault;
    //[self presentViewController:genreVC animated:YES completion:nil];
    [self.navigationController pushViewController:genreVC animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)sortClick:(id)sender {
    PopViewController *sortVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Pop"];
    NSDictionary *dict=[self.provider getSortingDictionary];
    //sortVC.selectedItem = [dict valueForKey:self.sortingKey];
    sortVC.dataArray = [dict allValues];
    /*sortVC.myBlock=^(NSString *selectedItem)
    {
        pageCount=1;
        if ([selectedItem isEqualToString:@"Popularity"]) {
            self.sortingKey=@"popularity";
            self.movieUrl = [NSString stringWithFormat: @"%@%@&%@&%@",moviesPopular,apiV3Key,lang,page];
        }
        else{
            self.sortingKey=@"voteAverage";
            self.movieUrl = [NSString stringWithFormat: @"%@%@&%@&%@",moviesTopRated,apiV3Key,lang,page];
        }
        [self updateTableWithSorting:self.sortingKey];
        [self downloadMoviesWithDeleting:YES withTableReloading:true];
    };*/
    //sortVC.modalPresentationStyle = UIActionSheetStyleDefault;
    //[self presentViewController:sortVC animated:YES completion:nil];
    [self.navigationController pushViewController:sortVC animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)settingsChoosedWithResult:(NSMutableDictionary *)result{
    self.selectedGenreDictionary = result;
    if ([[self.selectedGenreDictionary valueForKey:@"All"]boolValue]) {
        <#statements#>
    }
}


//uicollectionview; flow layout=horizontal
//urlcache

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    if (row != NSNotFound)
    {
        DetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
        NSObject *movie = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self presentViewController:viewController animated:YES completion:nil];
        [viewController configureVCwithObject:movie withObjectType:@"Movie"];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableViewCell *cell = (MovieTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.myTableView.contentOffset.y >= (self.myTableView.contentSize.height - self.myTableView.frame.size.height*2) && self.myTableView.contentSize.height>0)
    {
            if (downloadFlag)
            {
                NSLog(@"downloading");
                [self.activityIndicator startAnimating];
                [self downloadMoviesWithDeleting:false withTableReloading:false];
            }
    }
    else if(self.myTableView.contentOffset.y<-120)
    {
            if (downloadFlag && !downloadingError)
            {
                NSLog(@"updating");
                [self.activityIndicator startAnimating];
                oldPageCount=pageCount;
                pageCount=1;
                [self downloadMoviesWithDeleting:true withTableReloading:false];
            }
    }

}

-(void)downloadMoviesWithDeleting:(bool)mode withTableReloading:(bool)reload
{
    downloadFlag = false;
    downloadFlag=false;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSString *url=[NSString stringWithFormat: @"%@=%d",self.movieUrl,pageCount];
        [self.provider updateContextWithEntity:self.movieEntity withUrl:url withDeleting:mode withBlock:^(NSError *error)
         {
             if (error==nil) {
                 downloadingError=false;
                 [self.activityIndicator stopAnimating];
                 pageCount++;
             } else {
                 NSLog(@"Updating error: %@",error.description);
                 [self.activityIndicator stopAnimating];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =[[self.fetchedResultsController sections] objectAtIndex:section];
    cellsCount=[sectionInfo numberOfObjects];
    return cellsCount;
}

- (void)configureCell:(MovieTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.posterImage.image=self.noImage;
    cell.tag = indexPath.row;
    Movie *movie = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.title.text = movie.title;
    cell.genre.text = [[[movie.genres allObjects] valueForKey:@"name"] componentsJoinedByString:@", "];
    cell.rating.text = [NSString stringWithFormat:@"%.1f", movie.voteAverage];
    NSString *path=[NSString stringWithFormat: @"%@%@", moviePosterImagesDB, movie.posterPath];
    [self.provider downloadImageWithUrl:path withBlock:^(UIImage *img,NSError *error)
    {
        if (error==nil) {
            if (cell.tag == indexPath.row) {
                cell.posterImage.image = img;
                [cell setNeedsLayout];
            }
        }
        else{
            NSLog(@"%@",error.description);
        }
    }];
}

-(void)updateTableWithSorting:(NSString *)sortName
{
    self.sortingKey=sortName;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:self.sortingKey ascending:NO];
    [[self.fetchedResultsController fetchRequest]setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    //[self.myTableView reloadData];
}

-(void)updateTableWithGenre:(NSString *)genreName
{
    self.genreKey=genreName;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:genreName ascending:NO];
    [[self.fetchedResultsController fetchRequest]setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    [self.myTableView reloadData];
}













/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

# pragma mark - Popover Presentation Controller Delegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // called when a Popover is dismissed
    NSLog(@"Popover was dismissed with external tap. Have a nice day!");
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return YES;
}

# pragma mark - FetchedResultConroller
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:self.sortingKey ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    self.fetchedResultsController.delegate = self;
    
    return self.fetchedResultsController;
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.myTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.myTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            NSLog(@"message from fetchResultChangeUpdate %@",indexPath);
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.myTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.myTableView endUpdates];
}


@end
