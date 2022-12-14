//
//  MnaShareLog.m
//  iMCOBandRealTekSDK_iOS
//
//  Created by zhuo on 2015/5/24.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "MnaShareLog.h"

@interface MnaShareLog ()
@property (nonatomic, strong) NSDateFormatter *parser;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSLock *lock;
@end
@implementation MnaShareLog

+(instancetype)shareMnaShareLog
{
    static MnaShareLog *realTekCommon = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        realTekCommon = [[MnaShareLog alloc]init];
        
    });
    return realTekCommon;
    
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.maxFileSize = 600; //kb
        _lock = [[NSLock alloc]init];
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 1;
        self.deBugLog = YES;
        self.parser = [[NSDateFormatter alloc] init];
        self.parser.dateStyle = NSDateFormatterNoStyle;
        self.parser.timeStyle = NSDateFormatterNoStyle;
        [self clearMonthAgoLogFile];
    }
    return self;
}



-(uint32_t )getDateValueWithYear:(uint8_t)year withMonth:(uint8_t)month withDay:(uint8_t)day withHour:(uint8_t)hour withMinute:(uint8_t)minute withSecond:(uint8_t)second
{
    uint32_t dateValue = (year << 26) + (month << 22) + (day << 17) + (hour << 12)  + (minute << 6) + second;
    return dateValue;
}



#pragma mark - Print
-(void)printLogWithBuffer:(Byte *)buffer andLength:(NSUInteger)length andLabel:(NSString *)flagStr
{
    if (self.deBugLog) {
        NSMutableString *s = [[NSMutableString alloc] initWithFormat:@"%@ %lu: [", flagStr,(unsigned long)length];
        
        for (NSUInteger i=0; i<length; i++) {
            [s appendString:[NSString stringWithFormat:@"%02x ", buffer[i]]];
        }
        [s appendString:@"]"];
        [[MnaShareLog shareMnaShareLog]printDebugInfo:s withLevel:Mna_Log_Debug];
    }
    
}

-(void)printDataBytes:(NSData *)data
{
    if (self.deBugLog) {
        const char *byte = [data bytes];
        NSUInteger length = [data length];
        for (int i=0; i<length; i++) {
            char n = byte[i];
            char buffer[9];
            buffer[8] = 0; //for null
            int j = 8;
            while(j > 0)
            {
                if(n & 0x01)
                {
                    buffer[--j] = '1';
                } else
                {
                    buffer[--j] = '0';
                }
                n >>= 1;
            }
            printf("%s ",buffer);
        }
        
    }
}

-(void)printDebugInfo:(NSString *)info
{
    if (self.deBugLog && info) {
        [self writeLogToFile:info];
    }
}

-(void)printDebugInfo:(NSString *)info withLevel:(Mna_Log_Level)level
{
    if (self.deBugLog) {
        NSString *preString = @"MnaDebug*****";
        NSString *remindString = @"💧Info";
        switch (level) {
            case Mna_Log_Info:
                remindString = @"💧Info";
                break;
            case Mna_Log_Debug:
                remindString = @"✅Debug";
                break;
            case Mna_Log_Error:
                remindString = @"❌Error";
                break;
            case Mna_Log_Warning:
                remindString = @"⚠️Warning";
                break;
            case Mna_Log_Important:
                remindString = @"❗️Important";
                break;
            default:
                break;
        }
        NSString *logString = [NSString stringWithFormat:@"%@%@ %@",preString,remindString,info];
       [self writeLogToFile:logString];
    }
}


#pragma mark - Log File

-(void)clearAllLogFile
{
    NSString *path = [self getLogPath];
    if ([self isFileExists:path]) {
        [self rmFilePath:path];
    }
}

-(void)clearMonthAgoLogFile
{
    NSString *path = [self getLogPath];
    if ([self isFileExists:path]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error;
        NSArray *fileNames = [fm contentsOfDirectoryAtPath:path error:&error];
        if (error) {
            NSString *info = [NSString stringWithFormat:@"Clear Month ago logs error:%@",error.localizedDescription];
            NSLog(@"%@",info);
        }
        if (fileNames) {
            [fileNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger index, BOOL *stop){
                NSString *preName = [name componentsSeparatedByString:@"."].firstObject;
                NSDate *date = [self dateWithString:preName formatString:@"yyyy-MM-dd" timeZone:[NSTimeZone systemTimeZone]];
                NSDate *now = [NSDate date];
                long long timeInterval = [now timeIntervalSinceDate:date];
                if (timeInterval >= (30*24*60*60)) {
                    NSString *info = [NSString stringWithFormat:@"Will Delete log file name:%@-prename:%@",name,preName];
                    [self printDebugInfo:info withLevel:Mna_Log_Warning];
                    NSString *filePath = [self getLogFilePathWithFileName:preName];
                    if ([self isFileExists:filePath]) {
                        [self rmFilePath:filePath];
                    }
                }
                
            }];
        }
    }
}


-(void)clearTodayLog
{
    NSString *path = [self getLogPath];
    if ([self isFileExists:path]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error;
        NSArray *fileNames = [fm contentsOfDirectoryAtPath:path error:&error];
        if (error) {
            NSString *info = [NSString stringWithFormat:@"Clear Month ago logs error:%@",error.localizedDescription];
            NSLog(@"%@",info);
        }
        if (fileNames) {
            [fileNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger index, BOOL *stop){
                NSString *preName = [name componentsSeparatedByString:@"."].firstObject;
                NSString *todayFileName = [self getTodayLogFileName];
                if ([preName isEqualToString:todayFileName]) {
                    NSString *filePath = [self getLogFilePathWithFileName:preName];
                    if ([self isFileExists:filePath]) {
                        [self rmFilePath:filePath];
                    }
                }
            }];
        }
    }
    
}


-(void)writeLogToFile:(NSString *)logInfo
{
    NSString *path = [self getTodayLogFilePath];
    NSDate *now = [NSDate date];
    NSString *dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *timeString = [self getStringWithDate:now formatString:dateFormat timeZone:[NSTimeZone systemTimeZone]];
    if (![self isFileExists:path]) {
        NSError *error;
        NSString *titleString = [NSString stringWithFormat:@"## Start Time %@",timeString];
        [titleString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSString *info = [NSString stringWithFormat:@"Write log file error:%@",error.localizedDescription];
            NSLog(@"%@",info);
        }
        [self addSkipBackupAttributeWithPath:path];
    }else{
        NSError *error = nil;
        NSFileManager *fileM = [NSFileManager defaultManager];
        NSDictionary *dict = [fileM attributesOfItemAtPath:path error:&error];
        if (!error && dict) {
            unsigned long long size = [dict fileSize];
            unsigned long long kb = size/1024;
            if (kb > self.maxFileSize) {
                //先移动文件
                NSString *newPath = [self getCurrentTimeLogFilePath];
                [self moveFileFromPath:path toPath:newPath];
                [self rmFilePath:path];
                [self writeLogToFile:logInfo];
            }
        }
        
        
    }
    __weak __typeof(self) weakSelf = self;
    [self.queue addOperationWithBlock:^{
        [weakSelf.lock lock];
        NSString *writeString = [NSString stringWithFormat:@"\n%@:%@",timeString,logInfo];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
        [fileHandle seekToEndOfFile];//将节点跳到文件末尾
        NSData *stringData = [writeString dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:stringData];
        [weakSelf.lock unlock];
    }];
}


-(NSString *)getCurrentTimeLogFilePath
{
    NSString *fileName = [self getTodayCurrentTimeFileName];
    NSString *filePath = [self getLogFilePathWithFileName:fileName];
    return filePath;
}

-(NSString *)getTodayCurrentTimeFileName
{
    NSDate *date = [NSDate date];
    NSString *dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    NSString *fileName = [self getStringWithDate:date formatString:dateFormat timeZone:[NSTimeZone systemTimeZone]];
    return fileName;
}


//移动文件
-(BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fromPath]) {
        NSLog(@"Error: fromPath Not Exist");
        return NO;
    }
    return [fileManager moveItemAtPath:fromPath toPath:toPath error:nil];
    
}



-(BOOL)isFileExists:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}



-(void)rmFilePath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) {
        NSError *error;
        [fm removeItemAtPath:path error:&error];
        if (error) {
            NSString *info = [NSString stringWithFormat:@"Delete Log path error:%@",error.localizedDescription];
            NSLog(@"%@",info);
        }
    }
}

-(NSString *)getTodayLogFilePath
{
    NSString *fileName = [self getTodayLogFileName];
    NSString *filePath = [self getLogFilePathWithFileName:fileName];
    return filePath;
}

-(NSString *)getLogDocument
{
    NSString *temRootPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    temRootPath = documentPath;
    NSString *filePath = [NSString stringWithFormat:@"%@/Logs",temRootPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(localLogRootPath)]) {
        filePath = [self.delegate localLogRootPath];
    }
    return filePath;
}


-(NSString *)getLogFilePathWithFileName:(NSString *)fileName
{
    NSString *logPath = [self getLogPath];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.txt",logPath,fileName];
    return filePath;
}

-(NSString *)getLogPath
{
    NSString *temRootPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    temRootPath = documentPath;
    NSString *filePath = [NSString stringWithFormat:@"%@/Logs",temRootPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(localLogRootPath)]) {
        filePath = [self.delegate localLogRootPath];
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fm fileExistsAtPath:filePath isDirectory:&isDir]) {
        NSError *error = nil;
        [fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSString *info = [NSString stringWithFormat:@"create log dir error:%@",error.localizedDescription];
            NSLog(@"%@",info);
        }
        [self addSkipBackupAttributeWithPath:filePath];
    }
    return filePath;
}

-(NSString *)getTodayLogFileName
{
    NSDate *date = [NSDate date];
    NSString *dateFormat = @"yyyy-MM-dd";
    NSString *fileName = [self getStringWithDate:date formatString:dateFormat timeZone:[NSTimeZone systemTimeZone]];
    return fileName;
}


- (NSString *)getStringWithDate:(NSDate *)date formatString:(NSString *)formatString timeZone:(NSTimeZone *)timeZone {
    
    if (formatString && date) {
        @synchronized (self.parser) {
            self.parser.timeZone = timeZone;
            self.parser.dateFormat = formatString;
            return [self.parser stringFromDate:date];
        }
    }
    return nil;
}


-(NSDate *)dateWithString:(NSString *)dateString formatString:(NSString *)formatString timeZone:(NSTimeZone *)timeZone
{
    if (dateString && formatString) {
        self.parser.timeZone = timeZone;
        self.parser.dateFormat = formatString;
        return [self.parser dateFromString:dateString];
    }else{
        return nil;
    }
    
}


- (BOOL)addSkipBackupAttributeWithPath:(NSString *)filePathString
{
    NSURL *URL = [NSURL fileURLWithPath:filePathString];
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                  forKey:NSURLIsExcludedFromBackupKey
                                   error:&error];
    if (!success) {
        NSString *info = [NSString stringWithFormat:@"Error excluding %@ from backup %@", [URL lastPathComponent], error] ;
        [self printDebugInfo:info withLevel:Mna_Log_Error];
    }
    return success;
}




@end
