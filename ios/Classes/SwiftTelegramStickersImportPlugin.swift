import Flutter
import UIKit
import TelegramStickersImport

public class SwiftTelegramStickersImportPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "telegram_stickers_import", binaryMessenger: registrar.messenger())
        let instance = SwiftTelegramStickersImportPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method=="import"){
            handleImport(call:call, result:result)
        }else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleImport(call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            let args = call.arguments as! Dictionary<String, Any?>
            
            let software = args["software"] as! String
            let isAnimated = args["isAnimated"] as! Bool
            let rawStickers = args["stickers"] as! [Dictionary<String, Any?>]
            
            
            let stickerSet = StickerSet(software: software, isAnimated: isAnimated)
            
            for sticker in rawStickers {
                let data = convertStickerData(input: sticker["data"] as! Dictionary<String, Any?>)
                let emojis = sticker["emojis"] as! [String]
                try stickerSet.addSticker(data: isAnimated == true ? .animation(data) : .image(data), emojis: emojis)
            }
            
            if(args["thumbnail"]!==nil){
                let thumbnail = args["thumbnail"] as! Dictionary<String, Any?>
                let data = convertStickerData(input: thumbnail["data"] as! Dictionary<String, Any?>)
                try stickerSet.setThumbnail(data:.image(data))
            }
            
            try stickerSet.import()
        } catch(StickersError.fileTooBig) {
            result(FlutterError(code: "1", message: "error while import", details: "fileTooBig"))
            return
        } catch(StickersError.invalidDimensions) {
            result(FlutterError(code: "2", message: "error while import", details: "invalidDimensions"))
            return
        } catch(StickersError.countLimitExceeded) {
            result(FlutterError(code: "3", message: "error while import", details: "countLimitExceeded"))
            return
        } catch(StickersError.dataTypeMismatch) {
            result(FlutterError(code: "4", message: "error while import", details: "dataTypeMismatch"))
            return
        } catch(StickersError.setIsEmpty) {
            result(FlutterError(code: "5", message: "error while import", details: "setIsEmpty"))
            return
        } catch {
            result(FlutterError(code: "6", message: "error while import", details: "unknown"))
            return
        }
        result("success")
    }
    
    private func convertStickerData(input: Dictionary<String, Any?>) -> Data {
        let uintInt8List =  input["bytes"] as! FlutterStandardTypedData
        let bytes = [UInt8](uintInt8List.data)
        return Data(bytes)
    }
}
