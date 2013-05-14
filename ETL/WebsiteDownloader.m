//
//  WebsiteDownloader.m
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "WebsiteDownloader.h"

@implementation WebsiteDownloader

+ (NSString *)downloadContentOfURL:(NSURL *)url
{
    NSString *contentOfWebsite = [NSString stringWithContentsOfURL:url
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
    return contentOfWebsite;
}

@end
