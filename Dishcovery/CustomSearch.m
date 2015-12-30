//
//  CustomSearch.m
//  Dishcovery
//
//  Created by Gargium on 12/26/15.
//  Copyright © 2015 Gargium. All rights reserved.
//

#import "CustomSearch.h"

@implementation CustomSearch


//https://www.googleapis.com/customsearch/v1?q=bjs&key=AIzaSyBTMyOq_ihH677VN-BwwV15TVviKunVF4o&cx=015953250158261179188:9pejrsb_z9g
+ (NSURL*) getImageURL:(NSString *)searchQuery {
    
    NSString *googleURLString = @"https://www.googleapis.com/customsearch/v1?q=";
    googleURLString = [googleURLString stringByAppendingString:searchQuery];
    googleURLString = [googleURLString stringByAppendingString:@"&num=1&searchType=image&key=AIzaSyBTMyOq_ihH677VN-BwwV15TVviKunVF4o&cx=015953250158261179188:9pejrsb_z9g"];
    googleURLString = [googleURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"Hitting this URL: %@", googleURLString);
    NSURL *googleCustomSearchURL = [NSURL URLWithString:googleURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:googleCustomSearchURL];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    NSLog(@"Data response: %@", response);

    NSArray *retrievedData = jsonArray[@"items"];
    NSLog(@"Output: %@", retrievedData[0]);
    
    NSDictionary *dataDict = retrievedData[0];
    NSLog(@"Image URL: %@", [dataDict objectForKey:@"link"]);

    return [NSURL URLWithString:[dataDict objectForKey:@"link"]];
}

@end
