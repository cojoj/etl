//
//  ETLModel.m
//  ETL
//
//  Created by Mateusz Zajac on 23.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "ETLModel.h"

@implementation ETLModel

@synthesize downloadedWebsitesContainer;
@synthesize extracedDataContainer;
@synthesize companiesCount;

- (id) init
{
    if ( self = [super init] )
    {
        // Init containers for websites source and extracted comapnies data 
        self.downloadedWebsitesContainer = [NSMutableDictionary dictionaryWithCapacity: 0];
        self.extracedDataContainer = [NSMutableDictionary dictionaryWithCapacity: 0];
    }
    
    return self;
}

+ (NSArray *) getArrayOfLetter
{
    return @[
             @"A",
             @"B",
             @"C"
            ];
}

+ (NSArray *) getArrayOfMarkets
{
    return @[
             @"NYSE",
             @"NASDAQ",
             @"AMEX"
            ];
}

@end
