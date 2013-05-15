//
//  WebsiteDownloader.h
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebsiteDownloader : NSObject

- (id)initWithURL:(NSURL *)url;
- (NSData *)downloadContentOfWebsite;
- (NSString *)showContentOfWebsite;

@end
