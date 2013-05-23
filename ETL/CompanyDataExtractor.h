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

@property (strong, nonatomic) NSString* websiteContent;
@property (assign) NSStringEncoding contentEncoding;


-(id) init;
-(NSArray *) extractDataFromWebsiteContent:(NSString *) websiteContent;

@end
