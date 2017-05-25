//
//  Movie+CoreDataClass.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/25/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor, Genre;

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Movie+CoreDataProperties.h"
