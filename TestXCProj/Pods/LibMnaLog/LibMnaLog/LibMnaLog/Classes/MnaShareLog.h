//
//  MnaShareLog.h
//  iMCOBandRealTekSDK_iOS
//
//  Created by zhuo on 2015/5/24.
//  Copyright © 2015年 zhuo. All rights reserved.
//


#define MnaNoFunctionNameLogToFile(logStr,level) {\
BOOL printFunctionName = NO; \
switch (level) {\
case Mna_Log_Debug:{\
MnaLogDebug(@"%@",(logStr));\
if (printFunctionName) {\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"✅Debug: %s [Line %d] %@",__PRETTY_FUNCTION__, __LINE__,(logStr)]];\
}\
else{\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"✅Debug:%@",(logStr)]];\
}\
}\
break;\
case Mna_Log_Info:{\
MnaLogInfo(@"%@",(logStr));\
if (printFunctionName) {\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"💧Info: %s [Line %d] %@",__PRETTY_FUNCTION__, __LINE__,(logStr)]];\
}\
else{\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"💧Info:%@",(logStr)]];\
}\
}\
break;\
case Mna_Log_Error:{\
MnaLogError(@"%@",(logStr));\
if (printFunctionName) {\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"❌Error: %s [Line %d] %@",__PRETTY_FUNCTION__, __LINE__,(logStr)]];\
}\
else{\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"❌Error:%@",(logStr)]];\
}\
}\
break;\
case Mna_Log_Warning:{\
MnaLogWarning(@"%@",(logStr));\
if (printFunctionName) {\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"⚠️Warning: %s [Line %d] %@",__PRETTY_FUNCTION__, __LINE__,(logStr)]];\
}\
else{\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"⚠️Warning:%@",(logStr)]];\
}\
}\
break;\
case Mna_Log_Important:{\
MnaLogImportant(@"%@",(logStr));\
if (printFunctionName) {\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"❗️Important: %s [Line %d] %@",__PRETTY_FUNCTION__, __LINE__,(logStr)]];\
}\
else{\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"❗️Important:%@",(logStr)]];\
}\
}\
break;\
default:\
break;\
}\
}\



#define MnaLogToFile(logStr,level) {\
BOOL printFunctionName = YES; \
switch (level) {\
case Mna_Log_Debug:{\
MnaLogDebug(@"%@",(logStr));\
if (printFunctionName) {\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"✅Debug: %s [Line %d] %@",__PRETTY_FUNCTION__, __LINE__,(logStr)]];\
}\
else{\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"✅Debug:%@",(logStr)]];\
}\
}\
break;\
case Mna_Log_Info:{\
MnaLogInfo(@"%@",(logStr));\
if (printFunctionName) {\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"💧Info: %s [Line %d] %@",__PRETTY_FUNCTION__, __LINE__,(logStr)]];\
}\
else{\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"💧Info:%@",(logStr)]];\
}\
}\
break;\
case Mna_Log_Error:{\
MnaLogError(@"%@",(logStr));\
if (printFunctionName) {\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"❌Error: %s [Line %d] %@",__PRETTY_FUNCTION__, __LINE__,(logStr)]];\
}\
else{\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"❌Error:%@",(logStr)]];\
}\
}\
break;\
case Mna_Log_Warning:{\
MnaLogWarning(@"%@",(logStr));\
if (printFunctionName) {\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"⚠️Warning: %s [Line %d] %@",__PRETTY_FUNCTION__, __LINE__,(logStr)]];\
}\
else{\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"⚠️Warning:%@",(logStr)]];\
}\
}\
break;\
case Mna_Log_Important:{\
MnaLogImportant(@"%@",(logStr));\
if (printFunctionName) {\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"❗️Important: %s [Line %d] %@",__PRETTY_FUNCTION__, __LINE__,(logStr)]];\
}\
else{\
[[MnaShareLog shareMnaShareLog]printDebugInfo:[NSString stringWithFormat:@"❗️Important:%@",(logStr)]];\
}\
}\
break;\
default:\
break;\
}\
}\

#ifdef DEBUG
#define MnaLog(fmt, ...) NSLog((fmt),##__VA_ARGS__);

#define MnaLogDebug(fmt, ...) NSLog((@"✅Debug: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define MnaLogInfo(fmt, ...) NSLog((@"💧Info: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define MnaLogWarning(fmt,...) NSLog((@"⚠️Warning: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define MnaLogError(fmt,...) NSLog((@"❌Error: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define MnaLogImportant(fmt,...) NSLog((@"❗️Important: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else
#define MnaLog(fmt, ...){};

#define MnaLogDebug(fmt, ...){};
#define MnaLogInfo(fmt, ...){};
#define MnaLogWarning(fmt,...){};
#define MnaLogError(fmt,...){};
#define MnaLogImportant(fmt,...){};


#endif

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,Mna_Log_Level)
{
    Mna_Log_Error = 0,
    Mna_Log_Info = 1,
    Mna_Log_Warning = 2,
    Mna_Log_Debug = 3,
    Mna_Log_Important = 4,
};

@protocol MnaLogProtocol <NSObject>

-(NSString *)localLogRootPath;//文件存储路径

-(BOOL)printFunctionName; //是否打印函数名称


@end

@interface MnaShareLog : NSObject

@property (nonatomic) BOOL deBugLog;

@property (nonatomic, weak) id<MnaLogProtocol>delegate;

@property (nonatomic, assign) NSInteger maxFileSize;//Since the Log file is too large to read and write at a slower speed, reenter the Log when it exceeds this size. 

+(instancetype)shareMnaShareLog;

-(NSString *)getLogDocument;//获取当前文件日志路径
-(NSString *)getTodayLogFilePath;//获取当天日志记录文件路径
-(void)printLogWithBuffer:(Byte *)buffer andLength:(NSUInteger)length andLabel:(NSString *)flagStr;
-(void)printDebugInfo:(NSString *)info withLevel:(Mna_Log_Level)level;
-(void)printDebugInfo:(NSString *)info;
-(void)clearAllLogFile;
-(void)clearMonthAgoLogFile;
-(void)clearTodayLog;

@end
