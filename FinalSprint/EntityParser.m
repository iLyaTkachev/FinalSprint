//
//  EntityParser.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/24/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "EntityParser.h"

@implementation EntityParser

-(void)newMovie:(NSObject *)newObject from:(NSDictionary *)jsonObject
{
    [newObject setValue:[jsonObject objectForKey:@"poster_path"] forKey:@"posterPath"];
    [newObject setValue:[jsonObject objectForKey:@"overview"] forKey:@"overview"];
    [newObject setValue:[jsonObject objectForKey:@"release_date"] forKey:@"releaseDate"];
    //([newMovie setValue:[jsonObject objectForKey:@"genre_ids"]) forKey:@"releaseDate"];
    
    [newObject setValue:[jsonObject objectForKey:@"title"] forKey:@"title"];
    [newObject setValue:[jsonObject objectForKey:@"popularity"] forKey:@"popularity"];
    [newObject setValue:[jsonObject objectForKey:@"vote_average"] forKey:@"voteAverage"];

}

@end
