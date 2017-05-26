//
//  JsonParser.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/24/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "JsonParser.h"
#import "Movie+CoreDataProperties.h"
#import "Genre+CoreDataProperties.h"
#import "coreDataProvider.h"

@implementation JsonParser //parse json to coreData

-(void)newMovie:(Movie *)newObject from:(NSDictionary *)jsonObject withGenreDict:(NSDictionary *)dict withContext:(NSManagedObjectContext *)context
{
    
    newObject.posterPath = [jsonObject objectForKey:@"poster_path"];
    newObject.overview = [jsonObject objectForKey:@"overview"];
    newObject.releaseDate = [jsonObject objectForKey:@"release_date"];
    newObject.title = [jsonObject objectForKey:@"title"];
    newObject.popularity = [[jsonObject objectForKey:@"popularity"] floatValue];
    newObject.voteAverage = [[jsonObject objectForKey:@"vote_average"] floatValue];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Genre" inManagedObjectContext:context];
    NSArray *idsArray=[jsonObject valueForKey:@"genre_ids"];
    NSMutableArray *genreObjects = [[NSMutableArray alloc]init];
    for (int i=0; i<idsArray.count; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"genreID = %lld",idsArray[i]];
        request.predicate = predicate;
        NSError *error = nil;
        NSArray *objs = [context executeFetchRequest:request error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
        if (objs.count > 0) {
            [genreObjects addObject:objs[0]];
            for(Genre *object in objs){
                NSLog(@"%@",object.name);
            }
        }
    }
    
    
    
    //NSArray *genreObjects =[coreDataProvider getGenresFromIdsArray:[jsonObject valueForKey:@"genre_ids"] withContext:context];
    //NSSet<Genre *> *set = [NSSet setWithArray:genreObjects];
    for (int i=0; i<genreObjects.count; i++) {
        [newObject addGenresObject:[genreObjects objectAtIndex:i]];
    }
}

-(void)newGenre:(Genre *)newObject from:(NSDictionary *)jsonObject
{
    newObject.genreID = [jsonObject objectForKey:@"id"];
    newObject.name = [jsonObject objectForKey:@"name"];
}
@end
