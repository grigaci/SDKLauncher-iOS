//
//  PackageResourceConnection.m
//  SDKLauncher-iOS
//
//  Created by Shane Meyer on 11/23/13.
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

#import "PackageResourceConnection.h"
#import "PackageDataResponse.h"
#import "PackageResourceResponse.h"
#import "PackageResourceServer.h"
#import "RDPackage.h"
#import "RDPackageResource.h"


static RDPackage *m_package = nil;


@implementation PackageResourceConnection


- (NSObject <HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
	if (m_package == nil ||
		method == nil ||
		![method isEqualToString:@"GET"] ||
		path == nil ||
		path.length == 0)
	{
		return nil;
	}

	if (path != nil && [path hasPrefix:@"/"]) {
		path = [path substringFromIndex:1];
	}

    NSObject <HTTPResponse> *response = nil;

	// Synchronize using a process-level lock to guard against multiple threads accessing a
	// resource byte stream, which may lead to instability.

	@synchronized ([PackageResourceServer resourceLock]) {
		RDPackageResource *resource = [m_package resourceAtRelativePath:path];

		if (resource == nil) {
			NSLog(@"No resource found! (%@)", path);
		}
		else if (resource.contentLength < 1000000) {

			// This resource is small enough that we can just fetch the entire thing in memory,
			// which simplifies access into the byte stream.  Adjust the threshold to taste.

			NSData *data = resource.data;

			if (data != nil) {
				PackageDataResponse *dataResponse = [[PackageDataResponse alloc] initWithData:data];
                if (resource.mimeType) {
                    dataResponse.contentType = resource.mimeType;
                }
                response = dataResponse;
			}
		}
		else {
			PackageResourceResponse *resourceResponse = [[PackageResourceResponse alloc] initWithResource:resource];
            response = resourceResponse;
		}
	}

	return response;
}


+ (void)setPackage:(RDPackage *)package {
	m_package = package;
}


@end
