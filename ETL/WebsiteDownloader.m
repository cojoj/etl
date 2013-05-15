//
//  WebsiteDownloader.m
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "WebsiteDownloader.h"

@implementation WebsiteDownloader

+ (NSData *)downloadContentOfURL:(NSURL *)url
{
    NSData *contentOfWebsite = [NSData dataWithContentsOfURL:url];
    return contentOfWebsite;
}

@end
