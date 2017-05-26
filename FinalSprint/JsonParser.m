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

-(void)newMovie:(Movie *)newObject from:(NSDictionary *)jsonObject withGenreDict:(NSDictionary *)dict
{
    
    [newObject setValue:[jsonObject objectForKey:@"poster_path"] forKey:@"posterPath"];
    [newObject setValue:[jsonObject objectForKey:@"overview"] forKey:@"overview"];
    [newObject setValue:[jsonObject objectForKey:@"release_date"] forKey:@"releaseDate"];
    NSArray *genreArr=[jsonObject objectForKey:@"genre_ids"];
    for (int i=0; i<genreArr.count; i++) {
        
    }
    //([newMovie setValue:[jsonObject objectForKey:@"genre_ids"]) forKey:@"releaseDate"];

    
    [newObject setValue:[jsonObject objectForKey:@"title"] forKey:@"title"];
    [newObject setValue:[jsonObject objectForKey:@"popularity"] forKey:@"popularity"];
    [newObject setValue:[jsonObject objectForKey:@"vote_average"] forKey:@"voteAverage"];
    
}

-(void)newGenre:(NSObject *)newObject from:(NSDictionary *)jsonObject
{
    [newObject setValue:[jsonObject objectForKey:@"id"] forKey:@"genreID"];
    [newObject setValue:[jsonObject objectForKey:@"name"] forKey:@"name"];
}
@end
