//
//  defines.h
//  GPImageRecognitionEngine
//
//  Author : Gaprot Dev Team
//  Copyright : (c) 2014年 Up-frontier, Inc. All rights reserved.
//

#ifndef GPImageRecognitionEngine_define_h
#define GPImageRecognitionEngine_define_h

/*!
 @enum GPFastRecognizerMatchingType
 @abstract キーポイントのマッチングモード
 @constant GPFixedValueMatching: 閾値を固定値で設定する。特徴量のハミング距離がこの値と同値か下回ると同一の特徴点として処理する。<br>推奨値:0.15 有効値:0.00~1.00
 @constant GPDynamicValueMatching: 閾値を動的に設定する。特徴量のハミング距離が小さい順に、そのハミング距離をd1,d2としたとき、d1が d2*param を下回れば、それを同一の特徴点として処理する。<br>推奨値:0.85 有効値:0.00~1.00
 */
enum {
	GPFixedValueMatching,
	GPDynamicValueMatching
}typedef GPFastRecognizerMatchingType;

/*!
 @enum GPRecognizerResultKey
 @abstract recognitionWithUIImage: での処理結果を格納するNSDictionaryのキー
 @constant GPRecognizerResultIsDetected NSNumber*(boolValue): このフレームで画像を認識したかどうか
 @constant GPRecognizerResultKeypointElapsedTime NSNumber*(doubleValue): キーポイントの検出にかかった時間
 @constant GPRecognizerResultDescriptionElapsedTime NSNumber*(doubleValue): 特徴量の抽出にかかった時間
 @constant GPRecognizerResultMatchElapsedTime NSNumber*(doubleValue): 特徴点のマッチングにかかった時間
 @constant GPRecognizerResultScore NSNumber*(floatValue): 認識した画像のスコア(0.00 ~ 1.00)
 @constant GPRecognizerResultProcessedImage UIImage*:	認識に用いた画像
 @constant GPRecognizerResultVisualWordTag NSString*: 認識した画像に付加されていたメタ情報
 @constant GPRecognizerResultDatasetTag NSString*: 認識に用いたデータセットに付加されていたメタ情報
 */
enum{
	GPRecognizerResultIsDetected,
	GPRecognizerResultKeypointElapsedTime,
	GPRecognizerResultDescriptionElapsedTime,
	GPRecognizerResultMatchElapsedTime,
	GPRecognizerResultScore,
	GPRecognizerResultProcessedImage,
	GPRecognizerResultVisualWordTag,
	GPRecognizerResultDatasetTag
}typedef GPRecognizerResultKey;

#endif