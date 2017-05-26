//
//  JsonParser.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/24/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonParser : NSObject

-(void)newMovie:(NSObject *)newObject from:(NSDictionary *)jsonObject withGenreDict:(NSDictionary *)dict;
-(void)newGenre:(NSObject *)newObject from:(NSDictionary *)jsonObject;

@end
