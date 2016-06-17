//
//  UseusInstance.h
//  快速生成单例(兼容ARC与MRC)
//
//  Created by Leo on 15/10/19.
//  Copyright (c) 2015 leo's. All rights reserved.
//

/**
 *  使用两句代码就可以快速生成单例(兼容ARC与MRC)
 *	假如有一个Instance的类要作为单例，我们可以这么做：
 *	第一步：在 .h文件中加入sharedInstance_h(name)， name就是你的类名，比如Instance,
 *	可以生成一个以shared开头的sharedInstance的静态方法声明。
 *
 *	第二部：在 .m文件中假如sharedInstance_m(name)，name就是你的类名，比如Instance,
 *	可以生成一个以shared开头的sharedInstance的静态方法的实现。
 *
 *	使用方法：
 *	Instance *instance = [[Instance alloc] init];
 *	Instance *instance2 = [Instance sharedInstance];
 */

#ifndef _____MRC__SharedInstance_h
#define _____MRC__SharedInstance_h

#if __has_feature(objc_arc) // 在ARC环境用
// 放在声明文件中(.h)
#define sharedInstance_h(name) + (instancetype)shared##name;
// 放在实现文件中(.m)
#define sharedInstance_m(name) static id instance = nil;\
+ (instancetype)shared##name {\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [[self alloc] init];\
});\
return instance;\
}\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [super allocWithZone:zone];\
});\
return instance;\
}\
+ (id)copyWithZone:(struct _NSZone *)zone { return instance; }

#else // 在MRC环境中用
// 放在声明文件中(.h)
#define sharedInstance_h(name) + (instancetype)shared##name;
// 放在实现文件中(.m)
#define sharedInstance_m(name) static id instance = nil;\
+ (instancetype)shared##name {\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [[self alloc] init];\
});\
return instance;\
}\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [super allocWithZone:zone];\
});\
return instance;\
}\
+ (id)copyWithZone:(struct _NSZone *)zone { return instance; }\
- (instancetype)retain { return instance; }\
- (NSUInteger)retainCount { return 1; }\
- (oneway void)release { }\
- (instancetype)autorelease { return instance; }
#endif

#endif
