//
//  ETLController.m
//  ETL
//
//  Created by Maciej Komorowski on 16.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "ETLController.h"
#import "AppDelegate.h"


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
    // Allow websites download only if ETL has done nothing so far
    if ( currentState != (EtlState) nothingDoneYet )
    {
        NSLog( @"Action not allowed with current ETL state." );
        return;
    }
    
    // Count websites to process
    double websiteCount = [[ETLModel getArrayOfMarkets] count] * [[ETLModel getArrayOfLetter] count];
            
    // Show progress bar
    [(AppDelegate *) [[NSApplication sharedApplication] delegate] showProgressBarPanelWithTitle:@"Ściąganie stron"];
    
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
            NSString *fullPath = [NSString stringWithFormat:@"%@/WebSources/%@.%@", [storage mainDirectoryPath], filename, TXT_EXTENSION];
            
            //Checking if, maybe, files with webSources are saved in the directory 
            if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath])
            {
                //Init WebsiteDownloader to download source codes of generated websites
                WebsiteDownloader *downloader = [[WebsiteDownloader alloc] initWithURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding];
                [storage saveContent:[downloader websiteSource]
                          toFilename:filename
                       withExtension:TXT_EXTENSION
                         inDirectory:@"WebSources"];
                [[etlModel downloadedWebsitesContainer] setObject:[downloader websiteSource] forKey:filename];
            
                // Updated progress bar
                double progressLevel = [[etlModel downloadedWebsitesContainer] count] / websiteCount * 100;
                [(AppDelegate *) [[NSApplication sharedApplication] delegate] updateProgressBarPanelWithProgressLevel:progressLevel];
            }
            //If the are we are doing nothing - just logging the proper information
            else
            {
                NSLog(@"Plik: %@, już istieje", fullPath);
            }

        }
    }
    
    // Hide progress bar
    [(AppDelegate *) [[NSApplication sharedApplication] delegate] hideProgressBarPanel];
    
    // Disable GUI download action button
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] downloadButton] setEnabled:NO];
    
    //Change ETL state
    currentState = (EtlState) websitesDownloaded;
    
}

-(void) extractCompanyData
{
    // Allow data extraction only after ETL has downloaded websites
    if ( currentState != (EtlState) websitesDownloaded )
    {
        NSLog( @"Action not allowed with current ETL state." );
        return;
    }
    
    // Show progress bar
    [(AppDelegate *) [[NSApplication sharedApplication] delegate] showProgressBarPanelWithTitle:@"Wyciąganie danych"];
    
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
        [storage saveContent:[data componentsJoinedByString:@""] toFilename:key withExtension:CSV_EXTENSION inDirectory:@"CSV"];
        
        // Updated progress bar
        double progressLevel = [[etlModel extracedDataContainer] count] / (double) [[etlModel downloadedWebsitesContainer] count] * 100;
        [(AppDelegate *) [[NSApplication sharedApplication] delegate] updateProgressBarPanelWithProgressLevel:progressLevel];
    }
    
    // Hide progress bar
    [(AppDelegate *) [[NSApplication sharedApplication] delegate] hideProgressBarPanel];
    
    // Disable GUI extract action button
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] extractButton] setEnabled:NO];
    
    //Change ETL state
    currentState = (EtlState) dataExtraced;
    
}

-(void) saveExtractedData
{
    // Allow data to be saved only after ETL has extraced companies data from websites source
    if ( currentState != (EtlState) dataExtraced )
    {
        NSLog( @"Action not allowed with current ETL state." );
        return;
    }
    
    // Disable GUI extract action button
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] saveButton] setEnabled:NO];
    // Disable GUI full cycle action button
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] fullCycleButton] setEnabled:NO];
    
    NSLog( @"saveParsedData" );
    
    //Change ETL state
    currentState = (EtlState) dataSaved;
}

-(void) fullCycle
{
    [self downloadWebsitesContent];
    [self extractCompanyData];
    [self saveExtractedData];
}

-(void) restart
{
    // Change ETLState to default state of the application after run
    currentState = (EtlState) nothingDoneYet;
    
    // Delete created ETL folder with files
    [[NSFileManager defaultManager] removeItemAtPath:[storage mainDirectoryPath] error:NULL];
    
    // Delete data base records
    
    // Enable buttons
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] downloadButton] setEnabled:YES];
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] extractButton] setEnabled:YES];
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] saveButton] setEnabled:YES];
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] fullCycleButton] setEnabled:YES];

}


@end
