//
//  ETLModel.h
//  ETL
//
//  Created by Mateusz Zajac on 23.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETLModel : NSObject

@property (strong, nonatomic)NSMutableDictionary *downloadedWebsitesContainer;
@property (strong, nonatomic)NSMutableDictionary *extracedDataContainer;
@property (assign)NSInteger companiesCount;

- (id) init;
+ (NSArray *) getArrayOfLetter;
+ (NSArray *) getArrayOfMarkets;

@end
