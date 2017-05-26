//
//  coreDataProvider.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/26/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "coreDataProvider.h"

@implementation coreDataProvider

+(NSArray *)getGenresFromIdsArray:(NSArray *)idsArray withContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Genre" inManagedObjectContext:context];
    
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
    return genreObjects;
}

@end
