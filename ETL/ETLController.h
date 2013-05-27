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

@interface ETLController : NSObject
{
    ETLModel *etlModel;
    FileStorage *storage;
}

-(id) init;
-(void) downloadWebsitesContent;
-(void) extractWebsitesContent;
-(void) saveParsedData;
-(void) fullCycle;

@end
