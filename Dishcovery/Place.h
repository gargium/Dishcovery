//
//  Place.h
//  Dishcovery
//
//  Created by Gargium on 12/24/15.
//  Copyright © 2015 Gargium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject <NSCoding>

@property NSMutableArray *dishes;
@property NSString *placeName;

- (instancetype)initWithPlaceName:(NSString *)name;
-(BOOL) addDish: (NSString*) name;
-(BOOL) removeDish: (NSString*) name;

@end
