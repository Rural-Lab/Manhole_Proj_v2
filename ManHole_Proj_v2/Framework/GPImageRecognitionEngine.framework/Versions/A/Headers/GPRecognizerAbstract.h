//
//  GPRecognizerAbstract.h
//  GPImageRecognitionEngine
//
//  Author : Gaprot Dev Team
//  Copyright : (c) 2014年 Up-frontier, Inc. All rights reserved.
//

#import "defines.h"

@interface GPRecognizerAbstract : NSObject
-(int) preLoopProcess;
-(int) postLoopProcess;
-(void)setDatasetTag:(NSString*)tag;
-(void)registerUIImages:(NSArray*)images tags:(NSArray*)tags;
-(void)saveToPath:(NSString*)filePath fileName:(NSString*)fileName;
-(void)loadFromPath:(NSString*)path fileName:(NSString*)fileName;
-(void)removeAll;
-(NSDictionary*) recognitionWithUIImage:(UIImage*)image;
@end
