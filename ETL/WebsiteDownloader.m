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

- (NSString *) downloadContentOfWebsite;

@end

@implementation WebsiteDownloader

@synthesize websiteSource;

- (id)initWithURL:(NSURL *)url encoding:(NSStringEncoding)encoding
{
    if (self = [super init])
    {
        // Set URL of website to be downladed
        [self setWebsiteURL:url];
        
        // Set encoding of website content
        if (!encoding)
        {
            [self setWebsiteEncoding:NSUTF8StringEncoding];
        }
        else
        {
            [self setWebsiteEncoding:encoding];
        }
        
        // Download website source
        [self setWebsiteSource:[self downloadContentOfWebsite]];
    }
    return self;
}

# pragma private

/**
 * Download content of website
 */
- (NSString *)downloadContentOfWebsite
{
    NSError *error = nil;
    // Try to download website source
    NSString *tmpWebsite = [NSString stringWithContentsOfURL:self.websiteURL encoding:NSUTF8StringEncoding error:&error];
    
    // If failed, show alert
    if ( !tmpWebsite )
    {
        NSAlert *downloadAlert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"Strona o adresie: %@, nie istnieje", self.websiteURL]
                                                 defaultButton:@"OK"
                                               alternateButton:nil
                                                   otherButton:nil
                                     informativeTextWithFormat:@""];
        [downloadAlert runModal];
        return nil;
    }
    // Else return webstie content
    else
    {
        return tmpWebsite;
    }
}

@end
