//
//  GPFineRecognizer.h
//  GPImageRecognitionEngine
//
//  Author : Gaprot Dev Team
//  Copyright : (c) 2014年 Up-frontier, Inc. All rights reserved.
//

#import "GPRecognizerAbstract.h"

/*!
 @class GPFineRecognizer
 @abstract 高精度な画像検出機能を提供する。
 */
@interface GPFineRecognizer : GPRecognizerAbstract

/*!
 @property resizeSize
 @abstract 特徴量抽出処理の高速化のために、内部的に画像を縮小する際の大きさ。
 @discussion
 小さくするほど計算量が少なくなるが、画像によっては急激に精度が落ちる。<br>
 既定値: 0<br>
 有効値: 0~640 (0はリサイズしない)
 */
@property (nonatomic) int resizeSize;

/*!
 @property maxDetectionNum
 @abstract 画像あたりの特徴点検出の最大数
 @discussion
 大きいほど精度が上がる。<br>
 1フレームあたりの計算量はおよそここで決まる。計算量は O(n)<br>
 既定値: 800<br>
 有効値: 1以上<br>
 ※特徴点生成時に指定した値より小さくすると認識率が大幅に低下します。
 */
@property (nonatomic) int maxDetectionNum;

/*!
 @method setDatasetTag:
 @abstract データセットにタグを設定する。
 @param tag データセットに設定するタグ
 */
-(void)setDatasetTag:(NSString*)datasetTag;

/*!
 @method registerUIImages:tags:
 @abstract データセットに画像を登録する。
 @param images 登録する画像リスト
 @param tags 登録する画像に対応するタグリスト
 */
-(void)registerUIImages:(NSArray*)images tags:(NSArray*)tags;

/*!
 @method saveToPath:fileName:
 @abstract 現在のデータセットをファイルに保存する。
 @param filePath 保存先のディレクトリ
 @param fileName 保存するファイルの名前(拡張子は自動付加されます)
 */
-(void)saveToPath:(NSString*)path fileName:(NSString*)fileName;

/*!
 @method loadFromPath:fileName:
 @abstract ファイルからデータセットを読み込む。
 @param filePath ファイルが存在するディレクトリ
 @param fileName 読み込むファイルの名前(拡張子は自動付加されます)
 */
-(void)loadFromPath:(NSString*)path fileName:(NSString*)fileName;

/*!
 @method removeAll
 @abstract データセットに登録されている画像を全て登録解除する。
 */
-(void)removeAll;

/*!
 @method recognitionWithUIImage:
 @abstract UIImageをクエリ画像としてデータセットから認識を行う。
 @param image クエリ画像
 @return 認識結果を返します。各値は、GPRecognizerResultKey をキーとするアイテムに格納されています。
 @ref GPRecognizerResultKey
 */
-(NSDictionary*) recognitionWithUIImage:(UIImage*)image;

@end
