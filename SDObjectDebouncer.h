//
//  SDObjectDebouncer.h
//
//  Created by Sean O'Connor on 4/09/2014.
//  Copyright (c) 2014 AESG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SDObjectDebouncer)
- (void)performSelector:(SEL)aSelector
             withObject:(id)anObject
   withDebounceDuration:(NSTimeInterval)duration;

@end
