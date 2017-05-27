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
    
    NSArray *genreObjects =[coreDataProvider getGenresFromIdsArray:[jsonObject valueForKey:@"genre_ids"] withContext:context];
    //NSSet<Genre *> *set = [NSSet setWithArray:genreObjects];
    for(Genre *object in genreObjects){
        NSLog(@"%@",object.name);
        [newObject addGenresObject:object];
    }
    
}

-(void)newGenre:(Genre *)newObject from:(NSDictionary *)jsonObject
{
    newObject.genreID = [jsonObject objectForKey:@"id"];
    newObject.name = [jsonObject objectForKey:@"name"];
}
@end
