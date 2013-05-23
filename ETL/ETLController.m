//
//  ETLController.m
//  ETL
//
//  Created by Maciej Komorowski on 16.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "ETLController.h"


@implementation ETLController

-(void) downloadWebsitesContent
{
    UrlGenerator* generator = [[UrlGenerator alloc] initWithPattern:@"http://udus.pl/{:market}/{:letter}.htm"];
    NSLog(@"%@", [generator generateUrlWithParameters:nil] );
}

-(void) parseWebsitesContent
{
    NSLog( @"parseWebsitesContent" );
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
