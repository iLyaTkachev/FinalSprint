//
//  Provider.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/15/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "Provider.h"
#import "URLConnection.h"
#import "Movie+CoreDataClass.h"
#import "Constants.h"

@implementation Provider

-(id)initWithContext:(NSManagedObjectContext *)context
{
    self=[super init];
    if(self)
    {
        self.context=context;
    }
    return self;
}

-(void)getObjectsFromURL:(NSString *)urlAdress
{
    NSURL *url = [NSURL URLWithString:urlAdress];
    URLConnection *con=[[URLConnection alloc]init];
    [con downloadData:url myBlock:^(NSData *data,NSError *error)
     {
         if (error.description==NULL) {
             //NSLog(@"no errors");
             __block NSArray *objArray=[[NSArray alloc]init];
             [self serializeObjectsFromData:data myBlock:^(NSArray *array)
              {
                  objArray=[array valueForKey:@"results"];
                  [self updateContextWithObjects:objArray];
              }];
         }
         else {NSLog(@"urlConnection error %@",error.description);}
     }];
}

-(void)serializeObjectsFromData:(NSData *)data myBlock:(void (^)(NSArray *))block
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSError *error = nil;
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(dataArray);
            });
        }
        else
        {
            NSLog(@"Serialization error %@",error.description);
        }
            });
}
-(void)updateContextWithObjects:(NSArray *)array
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
        for (int i=0;i<array.count; i++) {
            NSManagedObject *newMovie=[[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:self.context];
            [newMovie setValue:[[array objectAtIndex:i] objectForKey:@"title"] forKey:@"title"];
            [newMovie setValue:[[array objectAtIndex:i] objectForKey:@"poster_path"] forKey:@"posterPath"];
            [newMovie setValue:[[array objectAtIndex:i] objectForKey:@"popularity"] forKey:@"popularity"];
            [newMovie setValue:[[array objectAtIndex:i] objectForKey:@"vote_average"] forKey:@"voteAverage"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.context save:&error];
        });
    });

}
-(void)downloadNewMoviesFromPage:(int)page //withBlock: (void(^)()) block
{
    page++;
}

@end
