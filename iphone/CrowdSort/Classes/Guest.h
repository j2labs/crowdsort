//
//  Guest.h
//  CrowdSort
//
//  Created by jd on 4/27/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Guest : NSObject {
	NSString *gid;
	NSString *name;
	NSString *table_name;
	NSString *email;
	NSString *phone_number;
}

@property (nonatomic, retain) NSString gid;
@property (nonatomic, retain) NSString name;
@property (nonatomic, retain) NSString table_name;
@property (nonatomic, retain) NSString email;
@property (nonatomic, retain) NSString phone_number;

@end
