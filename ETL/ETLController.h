//
//  ETLController.h
//  ETL
//
//  Created by Maciej Komorowski on 16.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETLModel.h"
#import "UrlGenerator.h"
#import "CompanyDataExtractor.h"
#import "WebsiteDownloader.h"
#import "FileStorage.h"

#define TXT_EXTENSION @"txt"
#define CSV_EXTENSION @"csv"

/**
 * List of all possible ETL states
 */
typedef enum {
    nothingDoneYet = 1,
    websitesDownloaded,
    dataExtraced,
    dataSaved
} ETLState;

/**
 * Main program controller. Holds whole ETL logic.
 */
@interface ETLController : NSObject
{
    ETLModel *etlModel;
    FileStorage *storage;
    ETLState currentState;
}
/**
 * ETLController constructor
 */
- (id) init;

/**
 * Download from http://findata.co.nz websites source
 * with quotes and save it to both .txt file and ETL model container
 */
- (void) downloadWebsitesSource;

/**
 * Extract company data ( company name, symbol, quotes, company market value ) 
 * from previously downloaded web sources
 */
- (void) extractCompaniesData;

/**
 * Save extraced data of companies to persistent store
 */
- (void) saveExtractedData;

/**
 * Run full cycle of ETL program
 */
- (void) fullCycle;

/**
 * Delete all efects of ETL work
 */
- (void) restart;

/**
 * Make fetch request to the created SQLite database and displays
 */
- (NSArray *) makeFetchRequest;

/**
 * Flush data base
 */
- (void) deleteAllObjectsFromCoreData;

/**
 * Getter for FileStorage instance
 */
- (FileStorage *) getFileStorage;

/**
 * Getter for ETLModel instance
 */
- (ETLModel *) getETLModel;

/**
 * Getter for managedObjectContext
 */
- (NSManagedObjectContext *)managedObjectContext;

@end
