//
//  Place.m
//  Dishcovery
//
//  Created by Gargium on 12/24/15.
//  Copyright © 2015 Gargium. All rights reserved.
//

#import "Place.h"

@implementation Place {
    
}


-(BOOL) addDish: (NSString*) name {
    [self.dishes addObject:name];
    return true;
}

-(BOOL) removeDish: (NSString*) name {
    [self.dishes removeObject:name];
    return true;
}

- (id)initWithPlaceName:(NSString*) name {
    if (self = [super init])
    {
        self.placeName = name;
        _dishes = [[NSMutableArray alloc] init]; 
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]){
        self.dishes = [aDecoder decodeObjectForKey:@"dishes"];
        self.placeName = [aDecoder decodeObjectForKey:@"placeName"];
    }
    return self;

}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.dishes forKey:@"dishes"];
    [aCoder encodeObject:self.placeName forKey:@"placeName"];
    NSLog(@"Element Encoded");
}

@end
