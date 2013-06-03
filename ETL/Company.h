//
//  Company.h
//  ETL
//
//  Created by Mateusz Zajac on 28.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Company : NSManagedObject

/**
 * Market code of company
 */
@property (nonatomic, retain) NSString *code;

/**
 * Name of market where comapny is quoted
 */
@property (nonatomic, retain) NSString *market;

/**
 * Name of company
 */
@property (nonatomic, retain) NSString *name;

@end
