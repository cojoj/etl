//
//  ETLController.m
//  ETL
//
//  Created by Maciej Komorowski on 16.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "ETLController.h"


@implementation ETLController

-init
{
    // Init ETL model
//    etlModel = [[ETLModel alloc] init];
}

-(void) downloadWebsitesContent
{
    // Init generator to generate URL to given market quoutes of companies on given letter
    UrlGenerator *generator = [[UrlGenerator alloc] initWithPattern:@"http://udus.pl/{:market}/{:letter}.htm"];
    
//    for( NSString *market in [ETLModel getArrayOfMarkets] )
//    {
//        for( NSString *letter in [ETLModel getArrayOfLetter] )
//        {
//            NSLog( @"%@%@", market, letter );
//        }
//    }
    
    NSLog(@"%@", [generator generateUrlWithParameters:nil] );
}

-(void) extractWebsitesContent
{
    NSString *websiteContent = [[NSString alloc] initWithContentsOfFile: @"/Users/mateusz/Developer/ETL/ETL/sample.txt"];
    
//    NSLog( websiteContent );
    
    CompanyDataExtractor *extractor = [[CompanyDataExtractor alloc] init];
    
    NSArray *data = [extractor extractDataFromWebsiteContent:websiteContent];
    
    for( NSString* line in data )
    {
        NSLog( @"%@", line );
    }
                                 
}

-(void) saveParsedData
{
    NSLog( @"saveParsedData" );
}

-(void) fullCycle
{
    NSLog( @"fullCycle" );
}


@end
