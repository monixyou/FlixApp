//
//  Movie.m
//  FlixApp
//
//  Created by Monica Bui on 7/1/20.
//  Copyright © 2020 fbu. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.title = dictionary[@"title"];
    self.synopsis = dictionary[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = dictionary[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    self.posterURL = [NSURL URLWithString:fullPosterURLString];
    
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    self.backdropURL = [NSURL URLWithString:fullBackdropURLString];
    
    self.movieID = dictionary[@"id"];
    
    return self;
}

// create an array of movies from an array of dictionaries
+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries {
   NSMutableArray *movies = [NSMutableArray array];
   for (NSDictionary *dictionary in dictionaries) {
       Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
       [movies addObject:movie];
   }
   return movies;
}

@end
