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
@synthesize imageDict=imgDict;

-(id)initWithContext:(NSManagedObjectContext *)context
{
    self=[super init];
    if(self)
    {
        self.context=context;
        self.privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [self.privateContext setParentContext:self.context];
        imgDict = [[NSMutableDictionary alloc]init];
        
    }
    return self;
}

-(void)getObjectsFromURL:(NSString *)urlAdress withBlock: (void(^)(NSArray *, NSError *)) block
{
    NSURL *url = [NSURL URLWithString:urlAdress];
    URLConnection *con=[[URLConnection alloc]init];
    [con downloadData:url myBlock:^(NSData *data,NSError *error)
     {
         if (error==NULL)
         {
             NSLog(@"no errors");
             __block NSArray *objArray=[[NSArray alloc]init];
             [self serializeObjectsFromData:data myBlock:^(NSArray *array)
              {
                  objArray=[array valueForKey:@"results"];
                  [self updateContextWithObjects:objArray withBlock:block ];
              }];
         }
         else
         {
             NSLog(@"urlConnection error %@",error.description);
             block(nil,error);
         }
     }];
}

-(void)serializeObjectsFromData:(NSData *)data myBlock:(void (^)(NSArray * ))block
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
    [self.privateContext performBlock:^{
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:self.privateContext];
        for (NSDictionary *jsonObject in array) {
            NSManagedObject *newMovie=[[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:self.privateContext];
            [newMovie setValue:[jsonObject objectForKey:@"title"] forKey:@"title"];
            [newMovie setValue:[jsonObject objectForKey:@"poster_path"] forKey:@"posterPath"];
            [newMovie setValue:[jsonObject objectForKey:@"popularity"] forKey:@"popularity"];
            [newMovie setValue:[jsonObject objectForKey:@"vote_average"] forKey:@"voteAverage"];
        }
        NSError *error = nil;
        if (![self.privateContext save:&error]) {
            NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
        [self.context performBlockAndWait:^{
            NSError *error = nil;
            if (![self.context save:&error]) {
                NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                abort();
            }
            else{block();}
        }];
    }];

}
-(void)downloadNewMoviesFromPage:(int)pageCount withDeleting:(bool)mode withBlock: (void(^)(NSError *)) block
{
    if (mode) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:self.privateContext];
        [self deleteObjectsWithEntity:entity withContext:self.privateContext];
        pageCount=1;
    }
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSString *url=[NSString stringWithFormat: @"%@%@&%@&%@=%d",moviesPopular,apiV3Key,lang,page,pageCount];
        [self getObjectsFromURL:url withBlock:block];
    });
    
}
-(void)updateTableWithEntity:(NSEntityDescription *)entity withUrl:(NSString *)url withBlock: (void(^)(NSError *)) block
{
    
}

-(void)deleteObjectsWithEntity:(NSEntityDescription *) entity withContext:(NSManagedObjectContext *)moc withBlock: (void(^)(NSError *)) block
{
    [self.privateContext performBlock:^{
        NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
        [fetch setEntity:entity];
        NSArray * result = [moc executeFetchRequest:fetch error:nil];
        for (NSManagedObject *movie in result)
        {
            [moc deleteObject:movie];
        }
        NSError *error = nil;
        if (![moc save:&error]) {
            NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
            block(error);
            abort();
        }
        [self.context performBlockAndWait:^{
            NSError *error = nil;
            if (![self.context save:&error]) {
                NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                block(error);
                abort();
            }
        }];
    }];

}

-(void)downloadImageWithUrl:(NSString *)url withBlock:(void(^)(UIImage *)) block
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
    {
        if ([imgDict objectForKey:url]==NULL)
        {
        NSURL *urlObj = [NSURL URLWithString:url];
        URLConnection *con=[[URLConnection alloc]init];
        [con downloadData:urlObj myBlock:^(NSData *data,NSError *error)
         {
             if (error==NULL)
             {
                 UIImage* image = [[UIImage alloc] initWithData:data];
                 if (image)
                 {
                     [imgDict setObject:image forKey:url];
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
    }
    else
    {
        UIImage *existingImg =[imgDict objectForKey:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(existingImg);
        });
    }
    });
}

@end
