//
//  STSafeCategory.h
//  STSafeCategory
//
//  Created by Sola on 16/8/9.
//  Copyright © 2016年 tscc-sola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSafeCategory : NSObject

+ (instancetype)sharedInstance;

- (void)enableSafeCategory;

@end
