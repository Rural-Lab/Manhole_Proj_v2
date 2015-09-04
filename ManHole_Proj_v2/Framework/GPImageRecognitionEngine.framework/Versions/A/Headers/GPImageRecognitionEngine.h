//
//  GPImageRecognitionEngine.h
//  GPImageRecognitionEngine
//
//  Author : Gaprot Dev Team
//  Copyright : (c) 2014年 Up-frontier, Inc. All rights reserved.
//
/*!
 @header GPImageRecognitionEngine.h
 @abstract カメラを用いた画像認識を容易行うためのクラス
 */

#import <AVFoundation/AVFoundation.h>
#import "defines.h"
#import "GPImageRecognizer.h"

/*!
 @protocol GPImageRecognitionEngineDelegate
 @abstract 画像を認識した時のコールバックを受けるデリゲートプロトコル
 */
@protocol GPImageRecognitionEngineDelegate <NSObject>

/*!
 @method didImageRecognition:
 @abstract 画像を認識した時に呼ばれるコールバックメソッド
 @param result 認識結果が格納されている辞書
 */
-(void)didImageRecognition:(NSDictionary*)result;
@end

/*!
 @class GPImageRecognitionEngine
 @abstract カメラを用いた画像認識を容易行うためのクラス
 */
@interface GPImageRecognitionEngine : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>

/*!
 @property previewView
 @abstract カメラのプレビューを表示するビュー
 @discussion ビューの最前面にカメラのプレビューレイヤが生成されたり、削除されたりするため対象ビューのレイヤ操作は非推奨。
 */
@property (nonatomic) UIView* previewView;

/*!
 @property videoGravity
 @abstract プレビューレイヤの重心位置の設定。
 @discussion 詳細は AVFoundation の AVCaptureVideoPreviewLayer を参照。
 */
@property (nonatomic) NSString* videoGravity;

/*!
 @property delegate
 @abstract 画像検出テストをした時にコールバックを受け取るオブジェクト
 */
@property (nonatomic) id<GPImageRecognitionEngineDelegate> delegate;

/*!
 @property recognizer
 @abstract 利用する認識器
 */
@property (nonatomic) GPRecognizerAbstract* recognizer;

/*!
 @method sharedManager
 @abstract オブジェクトを取得する
 @discussion シングルトンのオブジェクトを取得する。allocは使わず、こちらを使ってオブジェクトを取得してください。
 @return シングルトンオブジェクト
 */
+(GPImageRecognitionEngine*)sharedManager;

/*!
 @method init
 @abstract オブジェクトを初期化する
 @discussion シングルトンのオブジェクトのプロパティが初期化される。
 @return 初期化されたオブジェクト
 */
-(id)init;

/*!
 @method start
 @abstract 画像認識を開始する
 @discussion カメラを用いて認識を開始する。開始すると検出テストが行われるたびにコールバックメソッドが呼ばれる。また、開始と同時にpreviewViewにプレビューレイヤが生成される。
 */

-(void)start;

/*!
 @method stop
 @abstract 画像認識を終了する
 @discussion カメラを停止して認識を終了する。同時にpreviewViewに差し込んだプレビュー用のレイヤが削除される。
 */
-(void)stop;

@end
