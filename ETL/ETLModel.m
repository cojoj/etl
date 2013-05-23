//
//  ETLModel.m
//  ETL
//
//  Created by Mateusz Zajac on 23.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "ETLModel.h"

@implementation ETLModel

@synthesize downloadedWebsitesContent;
@synthesize extracedCompaniesData;

+ (NSArray *) getArrayOfLetter
{
    return @[@"A", @"B", @"C"];
}

+ (NSArray *) getArrayOfMarkets
{
    return @[@"NYSE", @"NASDAQ", @"AMEX"];
}

@end
