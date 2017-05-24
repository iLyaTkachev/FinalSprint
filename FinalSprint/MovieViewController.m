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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *genreButton;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) Provider *provider;
@property (nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) NSEntityDescription *movieEntity;
@property(nonatomic,strong) UIImage *noImage;
@property(nonatomic,strong) NSString *sortingKey;
@end


@implementation MovieViewController

int pageCount;
int oldPageCount;
int cellsCount;
bool downloadFlag;
bool downloadingError;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSArray alloc]init];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.context = delegate.managedObjectContext;
    self.provider=[[Provider alloc]initWithContext:delegate.managedObjectContext];
    pageCount=1;
    downloadFlag=true;
    downloadingError=false;
    self.movieEntity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:self.context];
    self.noImage=[UIImage imageNamed:@"no_image.png"];
    self.sortingKey=@"popularity";
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    [self downloadMoviesWithDeleting:true];
   
}
- (IBAction)GenreClick:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"Pop"];
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.genreButton;
    popController.delegate = self;}
- (IBAction)update:(id)sender {
    
    //DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    //[self.navigationController pushViewController:detailVC animated:YES];
    
    //[self presentViewController:detailVC animated:YES completion:nil];
    
    self.sortingKey=@"voteAverage";
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:self.sortingKey ascending:NO];
    [[self.fetchedResultsController fetchRequest]setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    [self.myTableView reloadData];
    //[self.myTableView beginUpdates];
}

//uicollectionview; flow layout=horizontal
//urlcache

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create a view controller with the title as its
    // navigation title and push it.
    NSUInteger row = indexPath.row;
    if (row != NSNotFound)
    {
        // Create the view controller and initialize it with the
        // next level of data.
        DetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
        [[self navigationController] pushViewController:viewController animated:YES];
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
    //NSLog(@"message from cellForRowAtIndexPath %d",indexPath.row);
    //NSLog(@"offset === %f === %f",self.myTableView.contentOffset.y,(self.myTableView.contentSize.height - self.myTableView.frame.size.height*2));
    
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
                [self downloadMoviesWithDeleting:false];
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
                [self downloadMoviesWithDeleting:true];
            }
    }

}

-(void)downloadMoviesWithDeleting:(bool)mode
{
    downloadFlag=false;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    NSString *url=[NSString stringWithFormat: @"%@%@&%@&%@=%d",moviesPopular,apiV3Key,lang,page,pageCount];
    [self.provider updateTableWithEntity:self.movieEntity withUrl:url withDeleting:mode withBlock:^(NSError *error)
     {
         if (error==nil) {
             downloadingError=false;
             [self.activityIndicator stopAnimating];
             pageCount++;
         }
         else{
             NSLog(@"Updating error: %@",error.description);
             [self.activityIndicator stopAnimating];
             downloadingError=true;
             pageCount=oldPageCount;
         }
         downloadFlag=true;
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
            
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

///////////////////////////////////////////////////////////////////////////////
//FetchedResultConroller
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
