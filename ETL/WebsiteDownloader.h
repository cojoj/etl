//
//  WebsiteDownloader.h
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebsiteDownloader : NSObject

/**
 * Keep source of downloaded website 
 */
@property (strong, nonatomic) NSString *websiteSource;

/**
 * WebsiteDownloader constructor
 */
- (id)initWithURL:(NSURL *)url encoding:(NSStringEncoding)encoding;

@end
