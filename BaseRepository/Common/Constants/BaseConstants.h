//
//  BaseConstants.h
//  BaseRepository
//
//  Created by jiaxin on 2018/3/6.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

//创建单例
#ifndef SHARED_INSTANCE
#define SHARED_INSTANCE(InstanceName) \
+ (instancetype)sharedInstance \
{   \
static InstanceName * sharedInstance; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[InstanceName alloc] init]; \
}); \
return sharedInstance;\
}
#endif
