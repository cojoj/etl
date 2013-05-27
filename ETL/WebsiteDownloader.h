//
//  WebsiteDownloader.h
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebsiteDownloader : NSObject

@property (strong, nonatomic) NSString *websiteSource;

- (id)initWithURL:(NSURL *)url encoding:(NSStringEncoding)encoding;
- (NSString *) downloadContentOfWebsite;

@end
