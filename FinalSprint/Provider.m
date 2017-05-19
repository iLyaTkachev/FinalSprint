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

-(void)getObjectsFromURL:(NSString *)urlAdress withBlock: (void(^)()) block
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
                  [self updateContextWithObjects:objArray withBlock:block ];
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
-(void)updateContextWithObjects:(NSArray *)array withBlock: (void(^)()) block
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:self.context];
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
            block();
        });
    });

}
-(void)downloadNewMoviesFromPage:(int)pageCount withDeleting:(bool)mode withBlock: (void(^)()) block 
{
    if (mode) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:self.context];
        [self deleteObjectsWithEntity:entity withContext:self.context];
        pageCount=1;
    }
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSString *url=[NSString stringWithFormat: @"%@%@&%@&%@=%d",moviesPopular,apiV3Key,lang,page,pageCount];
        [self getObjectsFromURL:url withBlock:block];
    });
    
}
-(void)deleteObjectsWithEntity:(NSEntityDescription *) entity withContext:(NSManagedObjectContext *)moc
{
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSArray * result = [self.context executeFetchRequest:fetch error:nil];
    for (NSManagedObject *movie in result)
    {
        [self.context deleteObject:movie];
    }
}

-(void)downloadImageWithUrl:(NSString *)url withBlock:(void(^)(UIImage *)) block
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
    {
        NSURL *urlObj = [NSURL URLWithString:url];
        URLConnection *con=[[URLConnection alloc]init];
        [con downloadData:urlObj myBlock:^(NSData *data,NSError *error)
         {
             if (error.description==NULL)
             {
                 UIImage* image = [[UIImage alloc] initWithData:data];
                 if (image)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         block(image);
                     });
                 }
             }
             else
             {
                 NSLog(@"Image download error: %@",error.description);
             }
         }];
    });
}

@end
