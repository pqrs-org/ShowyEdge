// -*- mode: objective-c -*-

@import Cocoa;

#define weakify(VAR) \
  autoreleasepool {} \
  __weak __typeof(VAR) VAR##_weak_ = VAR;

#define strongify(VAR)                              \
  autoreleasepool {}                                \
  _Pragma("clang diagnostic push");                 \
  _Pragma("clang diagnostic ignored \"-Wshadow\""); \
  __strong typeof(VAR) VAR = VAR##_weak_;           \
  _Pragma("clang diagnostic pop");
