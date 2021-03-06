//
//  EPubViewController.h
//  SDKLauncher-iOS
//
//  Created by Shane Meyer on 6/5/13.
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

#import "BaseViewController.h"

@class Bookmark;
@class PackageResourceServer;
@class RDContainer;
@class RDNavigationElement;
@class RDPackage;
@class RDSpineItem;

@interface EPubViewController : BaseViewController <
	UIAlertViewDelegate,
	UIPopoverControllerDelegate,
	UIWebViewDelegate>
{
	@private UIAlertView *m_alertAddBookmark;
	@private RDContainer *m_container;
	@private int m_currentOpenPageCount;
	@private int m_currentPageCount;
	@private int m_currentPageIndex;
	@private BOOL m_currentPageProgressionIsLTR;
	@private int m_currentSpineItemIndex;
	@private NSString *m_initialCFI;
	@private BOOL m_moIsPlaying;
	@private RDNavigationElement *m_navElement;
	@private RDPackage *m_package;
	@private UIPopoverController *m_popover;
	@private PackageResourceServer *m_resourceServer;
	@private RDSpineItem *m_spineItem;
	@private __weak UIWebView *m_webView;
}

- (id)
	initWithContainer:(RDContainer *)container
	package:(RDPackage *)package;

- (id)
	initWithContainer:(RDContainer *)container
	package:(RDPackage *)package
	bookmark:(Bookmark *)bookmark;

- (id)
	initWithContainer:(RDContainer *)container
	package:(RDPackage *)package
	navElement:(RDNavigationElement *)navElement;

- (id)
	initWithContainer:(RDContainer *)container
	package:(RDPackage *)package
	spineItem:(RDSpineItem *)spineItem
	cfi:(NSString *)cfi;

@end
