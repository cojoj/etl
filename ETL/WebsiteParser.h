//
//  WebsiteParser.h
//  ETL
//
//  Created by Mateusz Zajac on 15.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebsiteParser : NSObject

- (id) initWithWebsiteContent:(NSString *)website regularExpression:(NSRegularExpression *)regEx;
- (BOOL) parse;

@end
