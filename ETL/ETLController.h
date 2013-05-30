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

typedef enum {
    nothingDoneYet = 1,
    websitesDownloaded,
    dataExtraced,
    dataSaved
} ETLState;

@interface ETLController : NSObject
{
    ETLModel *etlModel;
    FileStorage *storage;
    ETLState currentState;
}

-(id) init;
-(void) downloadWebsitesSource;
-(void) extractCompaniesData;
-(void) saveExtractedData;
-(void) fullCycle;
-(void) restart;

-(FileStorage *) getFileStorage;
-(ETLModel *) getETLModel;

@end
