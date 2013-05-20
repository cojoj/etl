//
//  WebsiteDownloader.m
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "WebsiteDownloader.h"

@interface WebsiteDownloader ()

@property (strong, nonatomic) NSURL *websiteURL;
@property (strong, nonatomic) NSData *websiteSource;
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

- (NSData *)downloadContentOfWebsite
{
    NSData *tmpWebsite = [NSData dataWithContentsOfURL:self.websiteURL];
    
    if (!tmpWebsite)
    {
        //NSLog(@"Ni chuja, nie ma takieiej strony!");
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

- (NSString *)getContentOfWebsite
{
    NSString *web = [[NSString alloc] initWithData:self.websiteSource encoding:NSUTF8StringEncoding];
    return web;
}

- (void)saveContentToFile:(NSString *)fileName withFileExtension:(NSString *)fileExtension
{
    NSString *path = [[NSString alloc] initWithFormat:@"%@/Desktop/%@.%@", NSHomeDirectory(), fileName, fileExtension];
    if ([self.websiteSource writeToFile:path atomically:YES])
    {
        NSLog(@"Zapisano do: %@", path);
    }
    else
    {
        NSLog(@"Zapis do pliku się nie powiódł");
    }
}

@end
