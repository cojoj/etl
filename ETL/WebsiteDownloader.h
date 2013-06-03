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
 * Property with web source of downloaded website saved with UF8 as a default encoding.
 */
@property (strong, nonatomic) NSString *websiteSource;

/**
 * Designeted initializer for class which downloads web source from given URL with encoding (default is UTF8).
 * Downloaded web source is saved to websiteSource property which is public
 */
- (id)initWithURL:(NSURL *)url encoding:(NSStringEncoding)encoding;

@end
