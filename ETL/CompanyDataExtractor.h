//
//  QuotesScrapper.h
//  ETL
//
//  Created by Maciej Komorowski on 22.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyDataExtractor : NSObject
{
    NSRegularExpression *regexTable;
    NSRegularExpression *regexQuotes;
}

/**
 * CompanyDataExtractor constructor
 * Init regular expresions to be used during data extraction
 */
-(id) init;

/**
 * Extract companies data from website source 
 */
-(NSArray *) extractDataFromWebsiteContent:(NSString *) websiteContent;

@end
