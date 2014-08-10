//
//  EPubOpenPage.m
//  SDKLauncher-iOS
//
//  Created by Bogdan Iusco on 8/10/14.
//  Copyright (c) 2014 Readium Foundation and/or its licensees. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//  3. Neither the name of the organization nor the names of its contributors may be
//  used to endorse or promote products derived from this software without specific
//  prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
//  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
//  OF THE POSSIBILITY OF SUCH DAMAGE.

#import "EPubOpenPage.h"

@interface EPubOpenPage ()

@property (nonatomic, copy, readwrite) NSString *idref;
@property (nonatomic, assign, readwrite) NSUInteger spineItemIndex;
@property (nonatomic, assign, readwrite) NSUInteger spineItemPageCount;
@property (nonatomic, assign, readwrite) NSUInteger spineItemPageIndex;

@end

@implementation EPubOpenPage

#pragma mark - Constants

NSString * const kIDRefKey = @"idref";
NSString * const kSpineItemIndexKey = @"spineItemIndex";
NSString * const kSpineItemPageCount = @"spineItemPageCount";
NSString * const kSpineItemPageIndex = @"spineItemPageIndex";

#pragma mark - Initializers

+ (instancetype)epubOpenPageFromDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self loadDataFromDictionary:dictionary];
    }
    return self;
}

#pragma mark - Public methods

- (BOOL)isGreaterThan:(EPubOpenPage *)anotherOpenPage {
    // Compare if those two pages are from different spines
    if (self.spineItemIndex > anotherOpenPage.spineItemIndex) {
        return YES;
    }
    else if (self.spineItemIndex < anotherOpenPage.spineItemIndex) {
        return NO;
    }
    
    // Same spine, compare page index
    if (self.spineItemPageIndex > anotherOpenPage.spineItemPageIndex) {
        return YES;
    }
    else if (self.spineItemPageIndex < anotherOpenPage.spineItemPageIndex) {
        return NO;
    }
    
    // Pages are identical
    return NO;
}

- (BOOL)isSmallerThan:(EPubOpenPage *)anotherOpenPage {
    // Compare if those two pages are from different spines
    if (self.spineItemIndex < anotherOpenPage.spineItemIndex) {
        return YES;
    }
    else if (self.spineItemIndex > anotherOpenPage.spineItemIndex) {
        return NO;
    }
    
    // Same spine, compare page index
    if (self.spineItemPageIndex < anotherOpenPage.spineItemPageIndex) {
        return YES;
    }
    else if (self.spineItemPageIndex > anotherOpenPage.spineItemPageIndex) {
        return NO;
    }
    
    // Pages are identical
    return NO;
}

#pragma mark - Private methods

- (void)loadDataFromDictionary:(NSDictionary *)dictionary {
    self.idref = dictionary[kIDRefKey];
    self.spineItemIndex = [dictionary[kSpineItemIndexKey] unsignedIntegerValue];
    self.spineItemPageCount = [dictionary[kSpineItemPageCount] unsignedIntegerValue];
    self.spineItemPageIndex = [dictionary[kSpineItemPageIndex] unsignedIntegerValue];
}

@end
