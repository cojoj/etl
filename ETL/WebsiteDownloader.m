///Users/mckomo/Dropbox/Programy/Objective-C/ETL/ETL.xcodeproj
//  WebsiteDownloader.m
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "WebsiteDownloader.h"

@interface WebsiteDownloader ()

@property (strong, nonatomic) NSURL *websiteURL;
@property (nonatomic) NSStringEncoding websiteEncoding;

@end

@implementation WebsiteDownloader

- (id)initWithURL:(NSURL *)url encoding:(NSStringEncoding)encoding
{
    if (self = [super init])
    {
        [self setWebsiteURL:url];
        
        if (!encoding)
        {
            [self setWebsiteEncoding:NSUTF8StringEncoding];
        }
        else
        {
            [self setWebsiteEncoding:encoding];
        }

        [self setWebsiteSource:[self downloadContentOfWebsite]];
    }
    return self;
}

- (NSString *)downloadContentOfWebsite
{
    NSError *error = nil;
    NSString *tmpWebsite = [NSString stringWithContentsOfURL:self.websiteURL encoding:NSUTF8StringEncoding error:&error];
    
    if (!tmpWebsite)
    {
        NSAlert *downloadAlert = [NSAlert alertWithMessageText:@"Ni chuja, nie ma takieiej strony!"
                                                 defaultButton:@"OK"
                                               alternateButton:nil
                                                   otherButton:nil
                                     informativeTextWithFormat:@""];
        [downloadAlert runModal];
        return nil;
    }
    else
    {
        return tmpWebsite;
    }
}

@end
