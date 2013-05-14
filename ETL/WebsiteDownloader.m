//
//  WebsiteDownloader.m
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "WebsiteDownloader.h"

@implementation WebsiteDownloader
- (WebsiteDownloader *) WebsiteDownloader
{
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://komorowski.info"]];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog( @"Got data" );
    NSLog( data );
}

@end
