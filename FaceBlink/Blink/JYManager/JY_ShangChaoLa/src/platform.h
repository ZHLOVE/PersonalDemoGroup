#ifndef VENPOO_PLATFORM_H_
#define VENPOO_PLATFORM_H_

#if defined(__APPLE__) && defined(__MACH__)

#include <TargetConditionals.h>
#if TARGET_IPHONE_SIMULATOR == 1
#define VENPOO_IOS
#elif TARGET_OS_IPHONE == 1
#define VENPOO_IOS
#endif

#endif  // __APPLE__ __MACH__

#endif  // VENPOO_PLATFORM_H_
