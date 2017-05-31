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

@implementation JsonParser //parse json to coreData

-(void)newMovie:(Movie *)newObject from:(NSDictionary *)jsonObject withGenreDict:(NSDictionary *)dict withContext:(NSManagedObjectContext *)context
{
    @try {
        newObject.posterPath = [jsonObject objectForKey:@"poster_path"];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }

    newObject.overview = [jsonObject objectForKey:@"overview"];
    newObject.releaseDate = [jsonObject objectForKey:@"release_date"];
    newObject.title = [jsonObject objectForKey:@"title"];
    newObject.popularity = [[jsonObject objectForKey:@"popularity"] floatValue];
    newObject.voteAverage = [[jsonObject objectForKey:@"vote_average"] floatValue];
    
    NSArray *genreObjects =[self getGenresFromIdsArray:[jsonObject valueForKey:@"genre_ids"] withContext:context];
    [newObject addGenres:[NSSet setWithArray:genreObjects]];
    
}

-(void)newGenre:(Genre *)newObject from:(NSDictionary *)jsonObject
{
    newObject.genreID = [jsonObject objectForKey:@"id"];
    newObject.name = [jsonObject objectForKey:@"name"];
}

-(NSArray *)getGenresFromIdsArray:(NSArray *)idsArray withContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Genre" inManagedObjectContext:context];
    
    NSMutableArray *genreObjects = [[NSMutableArray alloc]init];
    for (int i=0; i<idsArray.count; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"genreID == %@",idsArray[i]];
        request.predicate = predicate;
        NSError *error = nil;
        NSArray *objs = [context executeFetchRequest:request error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
        if (objs.count > 0) {
            [genreObjects addObject:objs[0]];
        }
    }
    return genreObjects;
}

@end
