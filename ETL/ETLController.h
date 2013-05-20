//
//  ETLController.h
//  ETL
//
//  Created by Maciej Komorowski on 16.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETLController : NSObject
{
    
}
-(void) downloadWebsitesContent;
-(void) parseWebsitesContent;
-(void) saveParsedData;
-(void) masterExplosion;
@end
