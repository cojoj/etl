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

@end

@implementation WebsiteDownloader

- (id)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        [self setWebsiteURL:url];
    }
    return self;
}

- (NSData *)downloadContentOfWebsite
{
    self.websiteSource = [NSData dataWithContentsOfURL:self.websiteURL];
    return self.websiteSource;
}

- (NSString *)showContentOfWebsite
{
    NSString *web = [[NSString alloc] initWithData:self.websiteSource encoding:NSUTF8StringEncoding];
    return web;
}

@end
