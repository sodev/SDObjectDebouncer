//
//  SDObjectDebouncer.m
//
//  Created by Sean O'Connor on 4/09/2014.
//  Copyright (c) 2014 AESG. All rights reserved.
//

#import "SDObjectDebouncer.h"
#import <objc/runtime.h>

@implementation NSObject (SDObjectDebouncer)

const char *kDictionaryOfSelectorsToBlock = "kDictionaryOfSelectorsAndObjectsToBlock";

- (void)performSelector:(SEL)aSelector
             withObject:(id)anObject
   withDebounceDuration:(NSTimeInterval)duration
{
    // TRACK PENDING SELECTORS FOR THIS OBJECT IN A DICTIONARY
	NSMutableDictionary *blockedSelectors = objc_getAssociatedObject(self, kDictionaryOfSelectorsToBlock);
	if(!blockedSelectors)
	{
        // CREATE THE BLOCKED SELECTORS DICTIONARY
		blockedSelectors = [NSMutableDictionary new];
        
        // ASSOCIATE THE CREATED DICTIONARY TO THIS OBJECT
		objc_setAssociatedObject(self, kDictionaryOfSelectorsToBlock, blockedSelectors, OBJC_ASSOCIATION_RETAIN);
	}
    
    // CHECK IF THIS SELECTOR HAS AN EXISTING OBJECT IN THE DICTIONARY
    // each object in the blocked selectors dictionary contains the BOOL isBlocked
    NSString *selectorString = NSStringFromSelector(aSelector);
    // the key for each selector dictionary is the selector string and the description of the passing object
    // passing a different object to the same object and selector will be treated differently
    NSString *keyString = [NSString stringWithFormat:@"%@-%@", selectorString, [anObject description]];
	BOOL selectorBlocked = [[blockedSelectors objectForKey:keyString] boolValue];
    // we only care if the selector is unblocked
    // unblocked selectors will be blocked and have a subsequent timer to unblock them added
    if (!selectorBlocked) {
        // BLOCK THE SELECTOR FOR SUBSEQUENT CALLS
        [blockedSelectors setObject:@YES forKey:keyString];
        
        // PERFORM THE SELECTOR AFTER THE SPECIFIED DELAYS
        [self performSelector:aSelector withObject:anObject afterDelay:duration];
        
        // SET TIMER TO UNBLOCK SELECTOR
        [self performSelector:@selector(unblockSelectorForKey:) withObject:keyString afterDelay:duration];
    }
}

-(void)unblockSelectorForKey:(NSString *)keyString
{
    // GET THE BLOCKED SELECTORS ASSOCIATED WITH THIS OBJECT
	NSMutableDictionary *blockedSelectors = objc_getAssociatedObject(self, kDictionaryOfSelectorsToBlock);
	
	// REMOVE THE SELECTOR SO THAT SELECTOR CAN BE CALLED AGAIN
	[blockedSelectors removeObjectForKey:keyString];
}

@end
