//
//  EPubReadingOptions.m
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

#import "EPubReadingOptions.h"
#import "EPubOpenPage.h"

@interface EPubReadingOptions ()

@property (nonatomic, strong) NSMutableOrderedSet *openPages;
@property (nonatomic, assign, readwrite) BOOL pageProgressionLTR;
@property (nonatomic, assign, readwrite) NSUInteger currentOpenPageCount;
@property (nonatomic, assign, readwrite) NSUInteger spineItemsCount;

@property (nonatomic, strong, readwrite) EPubOpenPage *currentOpenPageMin;
@property (nonatomic, strong, readwrite) EPubOpenPage *currentOpenPageMax;

@end


@implementation EPubReadingOptions

#pragma mark - Constants

NSString * const kIsFixedLayoutKey = @"isFixedLayout";
NSString * const kOpenPagesKey = @"openPages";
NSString * const kPageProgressionDirectionKey = @"pageProgressionDirection";
NSString * const kSpineItemCountKey = @"spineItemCount";


#pragma mark - Intializers

+ (instancetype)epubReadingOptionsFromDictionary:(NSDictionary *)dictionary {
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

- (BOOL)canNavigateForward {
    BOOL isLastSpine = self.currentOpenPageMax.spineItemIndex + 1 == self.spineItemsCount;
    BOOL isLastPage = self.currentOpenPageMax.spineItemPageIndex  + 1 == self.currentOpenPageMax.spineItemPageCount;
    return !(isLastSpine && isLastPage);
}

- (BOOL)canNavigateBack {
    BOOL isFirstSpine = self.currentOpenPageMin.spineItemIndex == 0;
    BOOL isFirstPage = self.currentOpenPageMin.spineItemPageIndex == 0;
    return !(isFirstSpine && isFirstPage);
}

#pragma mark - Property

- (NSMutableOrderedSet *)openPages {
    if (!_openPages) {
        _openPages = [NSMutableOrderedSet orderedSet];
    }
    return _openPages;
}

#pragma mark - Private methods

- (void)loadDataFromDictionary:(NSDictionary *)dictionary {
    // Set page progression
    id directionObject = dictionary[kPageProgressionDirectionKey];
    if ([directionObject isKindOfClass:[NSString class]]) {
        NSString *directionString = (NSString *)directionObject;
        self.pageProgressionLTR = ![directionString isEqualToString:@"rtl"];
    }
    else {
        self.pageProgressionLTR = YES;
    }

    // Set open pages
    NSDictionary *openPagesDictionary = dictionary[kOpenPagesKey];
    for (NSDictionary *openPageDictionary in openPagesDictionary) {
        EPubOpenPage *openPage = [EPubOpenPage epubOpenPageFromDictionary:openPageDictionary];
        [self.openPages addObject:openPage];
    }
    
    // Set spine items count
    self.spineItemsCount = [dictionary[kSpineItemCountKey] unsignedIntegerValue];

    self.currentOpenPageCount = [self.openPages count];
    [self establishMinAndMaxOpenPages];
}

- (void)establishMinAndMaxOpenPages {
    NSUInteger countOpenPages = [self.openPages count];
    if (!countOpenPages) {
        NSLog(@"No open pages in %s", __FUNCTION__);
        return;
    }
    self.currentOpenPageMin = self.currentOpenPageMax = self.openPages[0];
    for (NSUInteger index = 1; index < countOpenPages; index++) {
        EPubOpenPage *openPage = self.openPages[index];
        if ([openPage isSmallerThan:self.currentOpenPageMin]) {
            self.currentOpenPageMin = openPage;
        }
        if ([openPage isGreaterThan:self.currentOpenPageMax]) {
            self.currentOpenPageMax = openPage;
        }
    }
}

@end
