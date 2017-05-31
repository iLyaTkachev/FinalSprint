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
#import "Genre+CoreDataClass.h"
#import "Constants.h"

@interface Provider()
@property (nonatomic,strong) NSMutableDictionary *imageDict;
@property (nonatomic,strong) JsonParser *parser;
@property (nonatomic,strong) NSDictionary *genreDict;
@end

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
        self.parser=[[JsonParser alloc]init];
        self.genreDict=[self getGenresDictionary];
        //[self updateGenresInContext];
    }
    return self;
}

-(void)getObjectsFromURL:(NSString *)urlAdress forEntity:(NSEntityDescription *)entity withBlock: (void(^)(NSArray *, NSError *)) block
{
    NSURL *url = [NSURL URLWithString:urlAdress];
    URLConnection *con=[[URLConnection alloc]init];
    [con downloadData:url myBlock:^(NSData *data,NSError *error)
     {
         if (error==NULL)
         {
             __block NSArray *objArray=[[NSArray alloc]init];
             [self serializeObjectsFromData:data myBlock:^(NSArray *array,NSError *serializeError)
              {
                  if (serializeError==nil) {
                      if ([entity.name isEqualToString:@"Movie"]){
                          objArray=[array valueForKey:@"results"];
                      }
                      else if ([entity.name isEqualToString:@"Genre"]){
                          objArray=[array valueForKey:@"genres"];
                      }
                      block(objArray,nil);
                  }
                  //[self updateContextWithObjects:objArray withBlock:block ];
                  else
                  {
                      NSLog(@"Serialization error %@",error.description);
                      block(nil,serializeError);
                  }
              }];
         }
         else
         {
             NSLog(@"urlConnection error %@",error.description);
             block(nil,error);
         }
     }];
}

-(void)serializeObjectsFromData:(NSData *)data myBlock:(void (^)(NSArray *, NSError *))block
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSError *error = nil;
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            block(dataArray,nil);
            });
        }
        else
        {
            block(nil,error);
        }
            });
}
-(void)updateContextWithObjects:(NSArray *)array withEntity:(NSEntityDescription *)entity1 withBlock: (void(^)(NSError *)) block
{
    [self.privateContext performBlock:^{
        NSEntityDescription *entity = [NSEntityDescription entityForName:entity1.name inManagedObjectContext:self.privateContext];
        
        if ([entity1.name isEqualToString:@"Movie"])
        {
            for (NSDictionary *jsonObject in array) {
                Movie *newItem=[[Movie alloc]initWithEntity:entity insertIntoManagedObjectContext:self.privateContext];
                [self.parser newMovie:newItem from:jsonObject withGenreDict:self.genreDict withContext:self.privateContext];
            }
        }
        else if([entity1.name isEqualToString:@"Genre"])
        {
            for (NSDictionary *jsonObject in array) {
                NSManagedObject *newItem=[[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:self.privateContext];
                [self.parser newGenre:newItem from:jsonObject];
            }
        }
                NSError *error = nil;
        if (![self.privateContext save:&error]) {
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
            else{block(nil);}
        }];
    }];

}

-(void)updateContextWithEntity:(NSEntityDescription *)entity withUrl:(NSString *)url withDeleting:(bool)mode withBlock: (void(^)(NSError *)) block
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self getObjectsFromURL:url forEntity:entity withBlock:^(NSArray *array,NSError *error)
         {
             if (error==nil) {
                 if (mode)//if true-delete objects
                 {
                     [self deleteObjectsWithEntity:entity withContext:self.privateContext withBlock:^(NSError *error)
                      {
                          if (error==nil) {
                              [self updateContextWithObjects:array withEntity:entity withBlock:^(NSError *error)
                               {
                                   if (error==nil)
                                   {
                                       block(nil);
                                   }
                                   else
                                   {
                                       block(error);
                                   }
                               }];
                          }
                          else
                          {
                              block(error);
                          }
                      }];
                 }
                 else//if false-simple update
                 {
                     [self updateContextWithObjects:array withEntity:entity withBlock:^(NSError *error)
                      {
                          if (error==nil)
                          {
                              block(nil);
                          }
                          else
                          {
                              block(error);
                          }
                      }];
                 }
             }
             else
             {
                 block(error);
             }
         }];
    });
    }

-(void)deleteObjectsWithEntity:(NSEntityDescription *) entity withContext:(NSManagedObjectContext *)moc withBlock: (void(^)(NSError *)) block
{
    NSEntityDescription *entityDel = [NSEntityDescription entityForName:entity.name inManagedObjectContext:moc];
    [moc performBlock:^{
        NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
        [fetch setEntity:entityDel];
        NSArray * result = [moc executeFetchRequest:fetch error:nil];
        for (NSManagedObject *item in result)
        {
            [moc deleteObject:item];
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
            block(nil);
        }];
    }];

}

-(void)downloadImageWithUrl:(NSString *)url withBlock:(void(^)(UIImage *,NSError *)) block
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
                         block(image,nil);
                     });
                 }
             }
             else
             {
                 NSLog(@"Image download error: %@",error.description);
                 block(nil,error);
             }
         }];
    }
    else
    {
        UIImage *existingImg =[imgDict objectForKey:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(existingImg,nil);
        });
    }
    });
}

-(void)downloadImageWithoutSavingWithUrl:(NSString *)url withBlock:(void(^)(UIImage *,NSError *)) block
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
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
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(image,nil);
                        });
                    }
                }
                else
                {
                    NSLog(@"Image download error: %@",error.description);
                    block(nil,error);
                }
            }];
       });
}


-(NSDictionary *)getSortingDictionary{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setValue:@"Popularity" forKey:@"popularity"];
    [dict setValue:@"Top Rated" forKey:@"vote_Average"];
    return dict;
}

-(NSDictionary *)getGenresDictionary {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Genre" inManagedObjectContext:self.context];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSArray *result = [self.context executeFetchRequest:fetch error:nil];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    for (NSDictionary *item in result)
    {
        [dict setValue:[item valueForKey:@"name"] forKey:[item valueForKey:@"genreID"]];
    }
    return dict;
}

-(void)updateGenresInContext{
    NSString *url=[NSString stringWithFormat: @"https://api.themoviedb.org/3/genre/movie/list?api_key=ac40e75b91cfb918546f4311f7623a89&language=en-US"];
                   //movieGenres,apiV3Key,lang];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Genre" inManagedObjectContext:self.context];
    [self updateContextWithEntity:entity withUrl:url withDeleting:YES withBlock:^(NSError *error)
     {
         if (error!=nil) {
             NSLog(@"%@",error.description);
         }
     }];
}

-(NSString *)getUrlPartFromGenres:(NSMutableDictionary *)selectedGenres{
    NSArray *arr = [selectedGenres allKeysForObject:[NSNumber numberWithBool:YES]];
    NSMutableArray *newArray = [[NSMutableArray alloc]init];
    for (NSString *genre in arr) {
        [newArray addObjectsFromArray: [self.genreDict allKeysForObject:genre]];
    }
    NSString *str = [newArray componentsJoinedByString:comma];
    return str;
}

@end
