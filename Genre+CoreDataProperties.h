//
//  Genre+CoreDataProperties.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/25/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "Genre+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Genre (CoreDataProperties)

+ (NSFetchRequest<Genre *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *genreID;
@property (nullable, nonatomic, copy) NSNumber *movieGenre;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *tvGenre;
@property (nullable, nonatomic, retain) Movie *movies;

@end

NS_ASSUME_NONNULL_END
