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

@interface MovieViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation MovieViewController

Provider *provider;
NSArray *dataArray;
int count;
int cellsCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [[NSArray alloc]init];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.context = delegate.managedObjectContext;
    provider=[[Provider alloc]initWithContext:delegate.managedObjectContext];
    //NSString *url=@"https://api.themoviedb.org/3/movie/popular?api_key=ac40e75b91cfb918546f4311f7623a89&language=en-US&page=%d";
    //[provider getObjectsFromURL:url];
    //[self retrieveInfo];
    count=1;
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
   
}
- (IBAction)update:(id)sender {
    //NSString *url1=@"https://api.themoviedb.org/3/movie/popular?api_key=ac40e75b91cfb918546f4311f7623a89&language=en-US&page=";
    //NSString *url=[NSString stringWithFormat: @"%@%d", url1, count];
    //[provider getObjectsFromURL:url];
    //count++;
    [provider downloadNewMoviesFromPage:count];
    NSLog(@"%d",count);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableViewCell *cell = (MovieTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    NSLog(@"message from cellForRowAtIndexPath %d",indexPath.row);
    NSLog(@"offset === %f === %f",self.myTableView.contentOffset.y,(self.myTableView.contentSize.height - self.myTableView.frame.size.height*2));
    if(self.myTableView.contentOffset.y<0)
    {
        NSLog(@"updating");
        [self.activityIndicator stopAnimating];
    }

    
                                                                                         
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIView *)scrollView
{
    /*if ()
    {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSString *url1=@"https://api.themoviedb.org/3/movie/popular?api_key=ac40e75b91cfb918546f4311f7623a89&language=en-US&page=";
            NSString *url=[NSString stringWithFormat: @"%@%d", url1, count];
            [provider getObjectsFromURL:url];
            count++;});
    }*/
    if(self.myTableView.contentOffset.y >= (self.myTableView.contentSize.height - self.myTableView.frame.size.height*2))
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [self.activityIndicator startAnimating];
            NSString *url1=@"https://api.themoviedb.org/3/movie/popular?api_key=ac40e75b91cfb918546f4311f7623a89&language=en-US&page=";
            NSString *url=[NSString stringWithFormat: @"%@%d", url1, count];
            [provider getObjectsFromURL:url];
            count++;});
        
        NSLog(@"downloading");
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =[[self.fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"================ %d",[sectionInfo numberOfObjects]);
    cellsCount=[sectionInfo numberOfObjects];
    return cellsCount;
}

- (void)retrieveInfo
{
    /*HTTPCommunication *http = [[HTTPCommunication alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/popular?api_key=ac40e75b91cfb918546f4311f7623a89&language=en-US&page=1"];
    
    [http retrieveURL:url myBlock:^(NSArray *array)
     {
         dataArray=[array valueForKey:@"results"];
         [self addMovies];
         //NSLog(@"%@",[[[array valueForKey:@"results"]objectAtIndex:0]valueForKey:@"title"]);
     }];*/
    
}
-(void) addMovies
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:self.context];
        NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
        [fetch setEntity:entity];
        NSArray * result = [self.context executeFetchRequest:fetch error:nil];
        for (Movie *movie in result)
        {
            [self.context deleteObject:movie];
        }
        __block NSError *error=nil;
        for (int i=0;i<dataArray.count; i++) {
            NSManagedObject *newMovie=[[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:self.context];
            [newMovie setValue:[[dataArray objectAtIndex:i] objectForKey:@"title"] forKey:@"title"];
            [newMovie setValue:[[dataArray objectAtIndex:i] objectForKey:@"poster_path"] forKey:@"posterPath"];
            [newMovie setValue:[[dataArray objectAtIndex:i] objectForKey:@"popularity"] forKey:@"popularity"];
            [newMovie setValue:[[dataArray objectAtIndex:i] objectForKey:@"vote_average"] forKey:@"voteAverage"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.context save:&error];
        });
    });
}


- (void)configureCell:(MovieTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Movie *movie = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.title.text = movie.title;
    cell.rating.text = [NSString stringWithFormat:@"%.1f", movie.voteAverage];
    
    /*dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSString *path=[NSString stringWithFormat: @"%@%@", imagesDB, movie.posterPath];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.posterImage.image=image;
            });
        }
    });*/
    
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
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"popularity" ascending:NO];
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
