//
//  Constants.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/11/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString * const apiV3Key = @"ac40e75b91cfb918546f4311f7623a89";
NSString * const apiV4Key = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhYzQwZTc1YjkxY2ZiOTE4NTQ2ZjQzMTFmNzYyM2E4OSIsInN1YiI6IjU4ZmY2NDQ5YzNhMzY4NTM5MDAwOGYxZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ksjE3-P8tNOFIQ_hk9f6LBcSZdjw7WpSkLzynhQeqN8";
NSString * const dataBaseURL = @"http://api.themoviedb.org/3/";
NSString * const dataBaseURLSSL = @"https://api.themoviedb.org/3/";
NSString * const moviePosterImagesDB = @"https://image.tmdb.org/t/p/w150/";
NSString * const moviesPopular = @"https://api.themoviedb.org/3/movie/popular?api_key=";
NSString * const moviesTopRated = @"https://api.themoviedb.org/3/movie/top_rated?api_key=";
NSString * const lang = @"language=en-US";
NSString * const page = @"page";
NSString * const movieGenres = @"https://api.themoviedb.org/3/genre/movie/list?api_key=";
NSString * const moviesByGenres1 = @"https://api.themoviedb.org/3/genre/";
NSString * const moviesByGenres2 = @"/movies?api_key=";
NSString * const moviesByGenres3 = @"&language=en-US&include_adult=false&sort_by=created_at.asc";
NSString * const movieDiscover1 = @"https://api.themoviedb.org/3/discover/movie?api_key=";
NSString * const movieDiscover2 = @"&language=en-US&sort_by=";
NSString * const movieDiscover3 = @".desc&include_adult=false&include_video=false&page=";
NSString * const movieDiscover4 = @"&with_genres=";
NSString * const comma = @"%2C";
@end
