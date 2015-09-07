#import "Recog.h"
#import <GPImageRecognitionEngine/GPImageRecognitionEngine.h>

@interface Recog () <GPImageRecognitionEngineDelegate>
@property (nonatomic) GPImageRecognitionEngine* recognitionEngine;
@end

@implementation Recog

- (void)RecogInit
{
    self.recognitionEngine = [GPImageRecognitionEngine sharedManager];  //画像認識エンジンを取得
    [self.recognitionEngine setPreviewView:self.view];                  //プレビューを表示するレイヤを指定する
    [self.recognitionEngine setDelegate:self];
    
    GPFineRecognizer *recognizer = [[GPFineRecognizer alloc] init];
    [recognizer loadFromPath:[[NSBundle mainBundle] resourcePath] fileName:@"Manhole"];
    
    [self.recognitionEngine setRecognizer:recognizer];
}

//検出したらアラートを出す
-(void)didImageRecognition:(NSDictionary*)result{
    @autoreleasepool
    {
        if([[result objectForKey:@(GPRecognizerResultIsDetected)] boolValue]){
            [self.recognitionEngine stop];
            self.recognitionEngine.delegate = nil;
            self.recognitionEngine = nil;
            
            _message = [result objectForKey:@(GPRecognizerResultVisualWordTag)];
            
            [self performSegueWithIdentifier:@"Info" sender:self];
            [self.view removeFromSuperview];
            
//            dispatch_async(dispatch_get_main_queue(), ^{
            
//                _message = [[NSString alloc]
//                                     initWithFormat:@"%@ : %@\nスコア : %.2f%%\n\nキーポイント検出 : %.3f秒\n特徴量の計算 : %.3f秒\nマッチング : %.3f秒\n"
//                                     , [result objectForKey:@(GPRecognizerResultDatasetTag)]
//                                     , [result objectForKey:@(GPRecognizerResultVisualWordTag)]
//                                     , [[result objectForKey:@(GPRecognizerResultScore)] floatValue] * 100
//                                     , [[result objectForKey:@(GPRecognizerResultKeypointElapsedTime)] doubleValue]
//                                     , [[result objectForKey:@(GPRecognizerResultDescriptionElapsedTime)] doubleValue]
//                                     , [[result objectForKey:@(GPRecognizerResultMatchElapsedTime)] doubleValue]];
////
////                [[[UIAlertView alloc] initWithTitle:@"検出結果" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"閉じる", nil] show];
//            });
            
        }
    }
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [self.recognitionEngine start]; //検出アラート後に再開
//}

-(void)viewDidAppear:(BOOL)animated{
    [self.recognitionEngine start];
}

@end
