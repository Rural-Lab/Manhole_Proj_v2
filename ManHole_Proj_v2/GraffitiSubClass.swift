import UIKit
import QuartzCore
import SceneKit

import CoreMotion
import CoreLocation
import AVFoundation

class GraffitiSubClass: UIViewController, CLLocationManagerDelegate, SCNSceneRendererDelegate {

    var tmpint=0
    
    var lm: CLLocationManager! = nil
    
    // create instance of MotionManager
    let motionManager: CMMotionManager = CMMotionManager()
    
    var degree = 0.0
    var a = 0.0
    var b = 0.0
    var c = 0.0
    
    var SaveArray:NSMutableArray?
    
    var RayBox_X:Float=0.0, RayBox_Y:Float=0.0, RayBox_Z:Float=0.0
    var InfoFlag = false
    var InfoButton:UIButton?
    var InfoCount = 0
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    
    // コンパスの値を受信
    func locationManager(manager:CLLocationManager, didUpdateHeading newHeading:CLHeading) {
        degree = (newHeading.magneticHeading/180)-1.0
        //degree = newHeading.magneticHeading
        a = newHeading.x
        b = newHeading.y
        c = newHeading.z
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func createword(name:String,x:Float,y:Float,z:Float){
        let scnView = self.view.viewWithTag(10) as! SCNView
        let scene = scnView.scene
        let cameraNode = scene?.rootNode.childNodeWithName("cameraNode", recursively: true)
//        let subBoxNode = cameraNode?.childNodeWithName("vectorNode", recursively: true)
        
        let text = SCNText(string: name, extrusionDepth: 1.0)
        let textNode = SCNNode(geometry: text)
//        textNode.name = name
        
        var v1 = SCNVector3Zero
        var v2 = SCNVector3Zero
        textNode.getBoundingBoxMin(&v1, max: &v2)
        
        textNode.pivot = SCNMatrix4Translate(textNode.transform, (v2.x + v1.x) * 0.5, (v2.y + v1.y) * 0.5, (v2.z + v1.z) * 0.5)
        textNode.scale = SCNVector3(x: -1.0, y: 1.0, z: 1.0)
        textNode.position = SCNVector3(x: x, y: y, z: z)
        
        let const = SCNLookAtConstraint(target: cameraNode!)
        const.gimbalLockEnabled = true
        textNode.constraints = [const]
        
        
        scene!.rootNode.addChildNode(textNode)
    }

    func createImage(Image:UIImage,x:Float,y:Float,z:Float,Type:String="None"){
        let scnView = self.view.viewWithTag(10) as! SCNView
        let scene = scnView.scene
        let cameraNode = scene?.rootNode.childNodeWithName("cameraNode", recursively: true)
        
        let Plane = SCNPlane(width: 20, height: 20)
        let material = SCNMaterial()
        material.diffuse.contents = Image
        Plane.firstMaterial = material
        
        let PlaneNode = SCNNode(geometry: Plane)
//        if let r = Type.rangeOfString("Info") {
        if (Type.rangeOfString("Info") != nil){
            PlaneNode.name = Type
        }
        
        var v1 = SCNVector3Zero
        var v2 = SCNVector3Zero
        PlaneNode.getBoundingBoxMin(&v1, max: &v2)
        
        PlaneNode.pivot = SCNMatrix4Translate(PlaneNode.transform, (v2.x + v1.x) * 0.5, (v2.y + v1.y) * 0.5, (v2.z + v1.z) * 0.5)
        PlaneNode.scale = SCNVector3(x: -1.0, y: 1.0, z: 1.0)
        PlaneNode.position = SCNVector3(x: x, y: y, z: z)
        
        let const = SCNLookAtConstraint(target: cameraNode!)
        const.gimbalLockEnabled = true
        PlaneNode.constraints = [const]
        
        scene!.rootNode.addChildNode(PlaneNode)
        
    }

 
    func sceneInit(ManHoleInfo:String = "None")->SCNNode{
        // シーンオブジェクトを作成。これ以降シーンオブジェクトのルートノードに
        // 子ノードを追加していくことでシーンにオブジェクトを追加していく。
        // ここではdaeファイル(3Dデータ)の読み込みを行っている。
        //let scene = SCNScene(named: "art.scnassets/ship.dae")
        let scene = SCNScene()
        
        let vector = SCNBox(width: 0, height: 0, length: 0, chamferRadius: 0.5)
        let vectorNode = SCNNode(geometry: vector)
        vectorNode.name = "vectorNode"
        vectorNode.position = SCNVector3(x: 0, y: 0, z: -50)
        
        // シーンオブジェクトを撮影するためのノードを作成
        let cameraNode = SCNNode()
        // カメラノードにカメラオブジェクトを追加
        cameraNode.camera = SCNCamera()
        cameraNode.name = "cameraNode"
        
        cameraNode.addChildNode(vectorNode)
        // シーンのルートノードにカメラノードを追加
        scene.rootNode.addChildNode(cameraNode)
        
        // カメラの位置を設定する。
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
        
        // シーンに光を与える為のノードを作成
        let lightNode = SCNNode()
        // ライトノードに光を表すライトオブジェクトを追加
        lightNode.light = SCNLight()
        // ライトオブジェクトの光属性を全方位への光を表す属性とする
        lightNode.light!.type = SCNLightTypeOmni
        // ライトオブジェクトの位置を設定する
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        // シーンのルートノードにライトノードを追加
        scene.rootNode.addChildNode(lightNode)
        
        // シーンに環境光を与える為に環境光ノードを作成
        let ambientLightNode = SCNNode()
        // 環境光ノードにライトオブジェクトを追加
        ambientLightNode.light = SCNLight()
        // ライトオブジェクトの光属性を環境光を表す属性とする
        ambientLightNode.light!.type = SCNLightTypeAmbient
        // 環境光の色を設定する
        ambientLightNode.light!.color = UIColor.whiteColor()
        // シーンのルートノードに環境光ノードを追加
        scene.rootNode.addChildNode(ambientLightNode)
        
        // ノード名を指定してshipのノードをシーンから取得する
        //let ship = scene!.rootNode.childNodeWithName("ship", recursively: true)!
        // shipに対してアニメーションを設定する。ここではy軸を中心とした永続的な回転を設定している。
        
//        let name = "Hello sonoda"
//        let text = SCNText(string: name, extrusionDepth: 1.0)
//        let textNode = SCNNode(geometry: text)
//        
//        var v1 = SCNVector3Zero
//        var v2 = SCNVector3Zero
//        textNode.getBoundingBoxMin(&v1, max: &v2)
//        
//        textNode.pivot = SCNMatrix4Translate(textNode.transform, (v2.x + v1.x) * 0.5, (v2.y + v1.y) * 0.5, (v2.z + v1.z) * 0.5)
//        
////        textNode.pivot = SCNMatrix4Rotate(cameraNode.transform, Float(M_PI), 0.0, 0.0, 0.0)
//        textNode.scale = SCNVector3(x: -1.0, y: 1.0, z: 1.0)
//        let const = SCNLookAtConstraint(target: cameraNode)
//        const.gimbalLockEnabled = true
//        textNode.constraints = [const]
//        
//        textNode.position = SCNVector3(x: 0.0, y: -50.0, z: 0.0)
//        
//        scene.rootNode.addChildNode(textNode)
        
        // シーンを表示するためのビューへの参照を取得
        
        let scnView = SCNView()
        scnView.frame = self.view.bounds
        
        if ManHoleInfo == "Manhole1" {
            scene.background.contents = [
                UIImage(named: "Img/skybox01/left.png")!,
                UIImage(named: "Img/skybox01/right.png")!,
                UIImage(named: "Img/skybox01/up.png")!,
                UIImage(named: "Img/skybox01/down.png")!,
                UIImage(named: "Img/skybox01/front.png")!,
                UIImage(named: "Img/skybox01/back.png")!
            ]
        }else if ManHoleInfo == "Manhole2"{
            scene.background.contents = [
                UIImage(named: "Img/skybox02/left.png")!,
                UIImage(named: "Img/skybox02/right.png")!,
                UIImage(named: "Img/skybox02/up.png")!,
                UIImage(named: "Img/skybox02/down.png")!,
                UIImage(named: "Img/skybox02/front.png")!,
                UIImage(named: "Img/skybox02/back.png")!
            ]
        }
        //        scnView.layer.addSublayer(myVideoLayer)
        // ビューのシーンに今までオブジェクトを追加してきたシーンを代入
        scnView.scene = scene
        
        // シーンに追加されたカメラを単純に操作できるようにする
        //        scnView.allowsCameraControl = true
        
        // ビューのフレーム数等のパフォーマンスに関わる統計情報をビューの下部に表示
        //        scnView.showsStatistics = true
        
        // ビューの背景色を黒に指定
        scnView.tag = 10
        scnView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(scnView)
        
        return cameraNode
    }
    
    func motionInit(){
        lm = CLLocationManager()
        // 位置情報を取るよう設定
        
        // ※ 初回は確認ダイアログ表示
        lm.requestAlwaysAuthorization()
        lm.delegate = self
        lm.distanceFilter = 1.0 // 1m毎にGPS情報取得
        lm.desiredAccuracy = kCLLocationAccuracyBest // 最高精度でGPS取得
        lm.startUpdatingLocation() // 位置情報更新機能起動
        lm.startUpdatingHeading() // コンパス更新機能起動
        
        // Initialize MotionManager
        motionManager.deviceMotionUpdateInterval = 0.05 // 20Hz
        
        let scnView = self.view.viewWithTag(10) as! SCNView
        let cameraNode = scnView.scene?.rootNode.childNodeWithName("cameraNode", recursively: true)
        var Info:[SCNNode] = []
        for i in 0..<InfoCount {
            let ChildName = "Info" + String(i+1)
            print(ChildName)
            let InfoNode = scnView.scene?.rootNode.childNodeWithName(ChildName, recursively: true)
            Info.append(InfoNode!)
        }
        let subBoxNode = cameraNode!.childNodeWithName("vectorNode", recursively: true)
        
        // Start motion data acquisition
        motionManager.startDeviceMotionUpdatesToQueue( NSOperationQueue.currentQueue()!, withHandler:{
            deviceManager, error in
            
            let attitude: CMAttitude = deviceManager!.attitude
//            let temp = attitude.yaw
//            println(temp)
            let quaternion: CMQuaternion = attitude.quaternion
            
            let gq1 = GLKQuaternionMakeWithAngleAndAxis(GLKMathDegreesToRadians(-90), 1, 0, 0)
            let gq2 = GLKQuaternionMake(Float(quaternion.x), Float(quaternion.y), Float(quaternion.z), Float(quaternion.w))
            let qp = GLKQuaternionMultiply(gq1, gq2)
            let rq = SCNVector4Make(qp.x, qp.y, qp.z, qp.w)
            
            cameraNode!.orientation = rq
            
            if self.InfoFlag {
                self.InfoButton?.hidden = true
                for i in 0..<self.InfoCount{
                    if Info[i].position.x - subBoxNode!.worldTransform.m41 > -7 && Info[i].position.x - subBoxNode!.worldTransform.m41 < 10{
                        if Info[i].position.y - subBoxNode!.worldTransform.m42 > -7 && Info[i].position.y - subBoxNode!.worldTransform.m42 < 10{
                            if Info[i].position.z - subBoxNode!.worldTransform.m43 > -7 && Info[i].position.y - subBoxNode!.worldTransform.m43 < 10{
                                self.InfoButton?.hidden = false
                                self.InfoButton?.tag = i+10
                            }
                            
                        }
                    }
                }
            }
        })
        
    }
    
    func SaveString(Text:String, ManholeName:String){
        let scnView = self.view.viewWithTag(10) as! SCNView
        let scene = scnView.scene
        let cameraNode = scene?.rootNode.childNodeWithName("cameraNode", recursively: true)
        let subBoxNode = cameraNode?.childNodeWithName("vectorNode", recursively: true)
        let x=Float(subBoxNode!.worldTransform.m41),y=Float(subBoxNode!.worldTransform.m42),z=Float(subBoxNode!.worldTransform.m43)
        
        createword(Text, x:x, y:y, z:z)
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        
        let fileName = ManholeName + "Data.dat"
        
        let filePath = (paths as NSString).stringByAppendingPathComponent(fileName)
        
        //保存するデータ
        let array:NSMutableArray = [
            "Text",
            Text,
            NSString(format: "%.2f", x),
            NSString(format: "%.2f", y),
            NSString(format: "%.2f", z)
        ]
        
        if let Dataarray = NSMutableArray(contentsOfFile: filePath){
            
            
            Dataarray.addObjectsFromArray(array as [AnyObject])
            //.componentsJoinedByString("\n")
            
            //アーカイブしてdata.datというファイル名で保存する
            //        let successful = NSKeyedArchiver.archiveRootObject(array, toFile: filePath)
            
            print(Dataarray)
            
            let successful = Dataarray.writeToFile(filePath, atomically: true)
            if successful{
                print("成功")
            }
        }else{
            let successful = array.writeToFile(filePath, atomically: true)
            if successful{
                print("成功")
            }
        }
    }
    
    func SaveImage(Image:UIImage, ManholeName:String){
        let scnView = self.view.viewWithTag(10) as! SCNView
        let scene = scnView.scene
        let cameraNode = scene?.rootNode.childNodeWithName("cameraNode", recursively: true)
        let subBoxNode = cameraNode?.childNodeWithName("vectorNode", recursively: true)
        let x=Float(subBoxNode!.worldTransform.m41),y=Float(subBoxNode!.worldTransform.m42),z=Float(subBoxNode!.worldTransform.m43)
        
        createImage(Image, x:x, y:y, z:z)
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        
        //保存するファイルの名前
        let fileName = ManholeName + "Data.dat"
        
        let filePath = (paths as NSString).stringByAppendingPathComponent(fileName)
        
        let fileManager = NSFileManager.defaultManager()
        //file exist?
        if !fileManager.fileExistsAtPath(filePath){
            let result : Bool = fileManager.createFileAtPath(filePath, contents:NSData(), attributes: nil)
            if !result{
                print("miss make file")
                return
            }
        }
        
        //保存するデータ
        let array:NSMutableArray = [
            "Image",
            Image2String(Image)!,
            NSString(format: "%.2f", x),
            NSString(format: "%.2f", y),
            NSString(format: "%.2f", z)
        ]
        
        if let Dataarray = NSMutableArray(contentsOfFile: filePath){
        
        
            Dataarray.addObjectsFromArray(array as [AnyObject])
            //.componentsJoinedByString("\n")
            
            //アーカイブしてdata.datというファイル名で保存する
    //        let successful = NSKeyedArchiver.archiveRootObject(array, toFile: filePath)
            
            print(Dataarray)
            
            let successful = Dataarray.writeToFile(filePath, atomically: true)
            if successful{
                print("成功")
            }
        }else{
            let successful = array.writeToFile(filePath, atomically: true)
            if successful{
                print("成功")
            }
        }
        
    }
    
    func LoadFile(ManholeName:String){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        
        //保存するファイルの名前
        let fileName = ManholeName + "Data.dat"
        
        let filePath = (paths as NSString).stringByAppendingPathComponent(fileName)
        
        let fileManager = NSFileManager.defaultManager()
        //file exist?
        if !fileManager.fileExistsAtPath(filePath){
            let result : Bool = fileManager.createFileAtPath(filePath, contents:NSData(), attributes: nil)
            if !result{
                print("miss make file")
                return
            }
        }
        
        if let array = NSArray(contentsOfFile: filePath) {
            
            for i in 0..<array.count/5 {
                if array[i*5] as! String == "Text"{
                    print("Text成功")
                    let text = array[i*5+1] as! String
                    let x = NSString(string: array[i*5+2] as! NSString).floatValue
                    let y = NSString(string: array[i*5+3] as! NSString).floatValue
                    let z = NSString(string: array[i*5+4] as! NSString).floatValue
                    print(text,x,y,z)
                    createword(text, x: x, y: y, z: z)
                }
                else if array[i*5] as! String == "Image"{
                    print("Image成功")
                    let image = String2Image(array[i*5+1] as! String)
                    let x = NSString(string: array[i*5+2] as! NSString).floatValue
                    let y = NSString(string: array[i*5+3] as! NSString).floatValue
                    let z = NSString(string: array[i*5+4] as! NSString).floatValue
                    print(image,x,y,z)
                    createImage(image!, x: x , y: y, z: z)
                }
                else{
                    print("ロード失敗")
                }
                
            }
        }
//        return String2Image(array[0] as! String)!
    }
    
    //UIImageをデータベースに格納できるStringに変換する
    func Image2String(image:UIImage) -> String? {
        
        //画像をNSDataに変換
        let data:NSData? = UIImagePNGRepresentation(image)
        
        //NSDataへの変換が成功していたら
        if let pngData = data {
            
            //BASE64のStringに変換する
            let encodeString:String =
            pngData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            
            return encodeString
            
        }
        
        return nil
        
    }
    
    //StringをUIImageに変換する
    func String2Image(imageString:String) -> UIImage?{
        
        
        //空白を+に変換する
        let base64String = imageString.stringByReplacingOccurrencesOfString(" ", withString:"+",options: [], range:nil)
        
        //BASE64の文字列をデコードしてNSDataを生成
        let decodeBase64:NSData? =
        NSData(base64EncodedString:base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
        //NSDataの生成が成功していたら
        if let decodeSuccess = decodeBase64 {
            
            //NSDataからUIImageを生成
            let img = UIImage(data: decodeSuccess)
            
            //結果を返却
            return img
        }
        
        return nil
        
    }
    
}
