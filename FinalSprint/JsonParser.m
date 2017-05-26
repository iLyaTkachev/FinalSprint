//
//  JsonParser.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/24/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "JsonParser.h"
#import "Movie+CoreDataProperties.h"

@implementation JsonParser

-(void)newMovie:(Movie *)newObject from:(NSDictionary *)jsonObject withGenreDict:(NSDictionary *)dict withContext:(NSManagedObjectContext *)context
{
    newObject.posterPath = [jsonObject objectForKey:@"poster_path"];
    newObject.overview = [jsonObject objectForKey:@"overview"];
    newObject.releaseDate = [jsonObject objectForKey:@"release_date"];
    newObject.title = [jsonObject objectForKey:@"title"];
    newObject.popularity = [[jsonObject objectForKey:@"popularity"] floatValue];
    newObject.voteAverage = [[jsonObject objectForKey:@"vote_average"] floatValue];
    
    NSArray *genreArr=[jsonObject objectForKey:@"genre_ids"];
    for (int i=0; i<genreArr.count; i++) {
        
    }
}

-(void)newGenre:(NSObject *)newObject from:(NSDictionary *)jsonObject
{
    [newObject setValue:[jsonObject objectForKey:@"id"] forKey:@"genreID"];
    [newObject setValue:[jsonObject objectForKey:@"name"] forKey:@"name"];
}
@end
