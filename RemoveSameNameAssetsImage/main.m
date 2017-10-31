//
//  main.m
//  RemoveSameNameAssetsImage
//
//  Created by 沈立京 on 2017/10/31.
//  Copyright © 2017年 Benster. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *fileList = [[NSArray alloc] init];
        
        //需要保留的图片路径
        NSMutableArray *savePathList = [NSMutableArray new];
        //要删除的图片路径
        NSMutableArray *pathList = [NSMutableArray new];
        
        //Assets位置
        NSString *basePath = @"/Users/benster_xmniao/Projects/OSChina/vrmu/jy_client/Assets.xcassets";
        fileList = [fileManager subpathsOfDirectoryAtPath:basePath error:&error];
        
        for (NSString * str in fileList) {
            NSString * temp = [str componentsSeparatedByString:@"/"].lastObject;
            if (![temp hasSuffix:@".png"]) continue;
            
            NSArray *temp2Arr1 = [str componentsSeparatedByString:@"/"];
            NSInteger index = temp2Arr1.count - 2;
            NSString *pathName = temp2Arr1[index];
            
            //遍历查询是否有相同图片名
            for (NSString * str2 in fileList) {
                NSString * temp2 = [str2 componentsSeparatedByString:@"/"].lastObject;
                if (![temp2 hasSuffix:@".png"]) continue;
                
                //是否是同一Assets下的图片
                NSString *imageName = nil;
                if ([str rangeOfString:@"@3x.png"].location != NSNotFound) {
                    imageName = [str substringToIndex:[str rangeOfString:@"@3x.png"].location];
                } else if ([str rangeOfString:@"@2x.png"].location != NSNotFound) {
                    imageName = [str substringToIndex:[str rangeOfString:@"@2x.png"].location];
                } else {
                    imageName = [str substringToIndex:[str rangeOfString:@".png"].location];
                }
                if ([str2 hasPrefix:imageName]) continue;
                
                NSArray *temp2Arr2 = [str2 componentsSeparatedByString:@"/"];
                NSInteger index2 = temp2Arr2.count - 2;
                NSString *pathName2 = temp2Arr2[index2];
                if ([pathName isEqualToString:pathName2]) {
                    NSString *newPath = [str2 substringToIndex:[str2 rangeOfString:pathName2].location + [str2 rangeOfString:pathName2].length];
                    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", basePath, newPath];
                    
                    for (int i = 0; i < savePathList.count; i ++) {
                        if ([[savePathList objectAtIndex:i] hasSuffix:pathName]) {
                            break;
                        } else if (i == savePathList.count - 1) {
                            [savePathList addObject:fullPath];
                        }
                    }
                    
                    if (savePathList.count == 0) {
                        [savePathList addObject:fullPath];
                    }
                    
                    if ([savePathList indexOfObject:fullPath] != NSNotFound) continue;
                    if ([pathList indexOfObject:fullPath] != NSNotFound) continue;
                    
                    [pathList addObject:fullPath];
                    NSLog(@"%@", fullPath);
                }
            }
        }
        
        //执行删除操作
//        for (NSString *pathName in pathList) {
//            NSError *error;
//            [fileManager removeItemAtPath:pathName error:&error];
//            if (error) {
//                NSLog(@"%@", error);
//            }
//        }
    }
    return 0;
}
