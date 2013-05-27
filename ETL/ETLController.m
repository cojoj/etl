//
//  ETLController.m
//  ETL
//
//  Created by Maciej Komorowski on 16.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "ETLController.h"


@implementation ETLController

- (id) init
{
    if (self = [super init])
    {
        etlModel = [[ETLModel alloc] init];
        storage = [[FileStorage alloc] initWithMainDirectoryAtPath:NSHomeDirectory() name:@"ETL"];
        currentState = (EtlState) nothingDoneYet;
    }
    return self;
}

-(void) downloadWebsitesContent
{
    // Allow websites download only if ETL has nothing yet
    if ( currentState != (EtlState) nothingDoneYet )
    {
        NSLog( @"Action not allowed with current ETL state." );
        return;
    }
    
    // Init generator to generate URL to given market quoutes of companies on given letter
    UrlGenerator *generator = [[UrlGenerator alloc] initWithPattern:@"http://findata.co.nz/Markets/$1/$2.htm"];
    [generator generateUrlWithParameters:@[@"1", @"2"]];

    //Creates subdirectory with websources
    [storage createDirectoryInMainDirectoryNamed:@"WebSources"];
    
    for( NSString *market in [ETLModel getArrayOfMarkets] )
    {
        for( NSString *letter in [ETLModel getArrayOfLetter] )
        {
            NSString *url= [generator generateUrlWithParameters:@[market, letter]];
            NSString *filename = [NSString stringWithFormat:@"%@_%@", market, letter];
            
            //Init WebsiteDownloader to download source codes of generated websites
            WebsiteDownloader *downloader = [[WebsiteDownloader alloc] initWithURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding];
            [storage saveContent:[downloader websiteSource]
                      toFilename:filename
                   withExtension:@"txt"
                     inDirectory:@"WebSources"];
            [[etlModel downloadedWebsitesContainer] setObject:[downloader websiteSource] forKey:filename];
        }
    }
    
    //Change ETL state
    currentState = (EtlState) websitesDownloaded;
    
}

-(void) extractWebsitesContent
{
    // Allow data extraction only after ETL has downloaded websites
    if ( currentState != (EtlState) websitesDownloaded )
    {
        NSLog( @"Action not allowed with current ETL state." );
        return;
    }
    
    // Create CSV folder for CSVs
    [storage createDirectoryInMainDirectoryNamed:@"CSV"];
    
    // Init extractor object
    CompanyDataExtractor *extractor = [[CompanyDataExtractor alloc] init];
        
    //Iterates through website container
    for ( NSString* key in [etlModel downloadedWebsitesContainer] )
    {
        //Extract company data from the stored website content
        NSArray *data = [extractor extractDataFromWebsiteContent:[[etlModel downloadedWebsitesContainer] objectForKey:key]];
        
        // Store data in etl container
        [[etlModel extracedDataContainer] setObject:data forKey:key];
        
        //Saving data to .csv file
        [storage saveContent:[data componentsJoinedByString:@"\n"] toFilename:key withExtension:@"csv" inDirectory:@"CSV"];
    }
    
    //Change ETL state
    currentState = (EtlState) dataExtraced;
    
}

-(void) saveExtracedData
{
    // Allow data to be saved only after ETL has extraced companies data from websites source
    if ( currentState != (EtlState) dataExtraced )
    {
        NSLog( @"Action not allowed with current ETL state." );
        return;
    }
    
    NSLog( @"saveParsedData" );
}

-(void) fullCycle
{
    [self downloadWebsitesContent];
    [self extractWebsitesContent];
    [self saveExtracedData];
}


@end
