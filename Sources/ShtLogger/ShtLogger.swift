import UIKit
import MessageUI

public class ShtLogger: NSObject {
    private override init() { }
    
    public static let shared = ShtLogger()
    public var logFileName = "Log program"
    public var isNotSave = false
    public var emails = [String]()
    public var subTitleLogFile = ""
    public var dateFormat = "dd.MM.YYYY HH:mm:ss"
    public var timeFormat = "[HH:mm:ss]"
    public var countLogFiles = 5
        
    private var isShowAlert = false
    private var lastFile: URL?
    private var lastFiles = [URL]()
    private let fileDateFormat = "YYYY-MM-dd HH"
    
    private var fileName: String {
        let format = DateFormatter()
        format.dateFormat = fileDateFormat
        let date = Date()
        let minute = Calendar.current.component(.minute, from: date)
        let half = minute < 30 ? "00" : "30"
        return logFileName + "-" + format.string(from: date) + "-" + half + ".txt"
    }
    
    public func log(event: ShtEventProtocol, text: String = "", isTopVCName: Bool = false, controller: UIViewController? = nil) {
        if isNotSave { return }
        let formater = DateFormatter()
        formater.dateFormat = timeFormat
        var log = formater.string(from: Date())
        log += " \(event.name) - \(event.rawValue)"
        if !text.isEmpty {
            log += " - \(text)"
        }
        if let vc = controller {
            log += " - \(String(describing: type(of: vc)))"
        } else if isTopVCName, let vc = topMostViewController() {
            log += " - \(String(describing: type(of: vc)))"
        }
        print(log)
        log += "\n"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: path.path) {
            do {
                var todos = try String(contentsOf: path)
                todos += log
                do {
                    try todos.write(to: path, atomically: true, encoding: .utf8)
                    if lastFile != path {
                        lastFiles.append(path)
                        lastFile = path
                        if lastFiles.count > countLogFiles, let firstPath = lastFiles.first {
                            deleteLogFile(url: firstPath)
                            lastFiles.removeFirst()
                        }
                    }
                } catch {
                    print("ERROR Logger - ", error.localizedDescription)
                    if !isShowAlert {
                        isShowAlert = true
                        showAlert(title: "Log file not writed", message: String(describing: error))
                    }
                }
            } catch {
                print("ERROR Logger - ", error.localizedDescription)
                if !isShowAlert {
                    isShowAlert = true
                    showAlert(title: "Log file not readed", message: String(describing: error))
                }
            }
        } else {
            let device = UIDevice.current
            let format = DateFormatter()
            format.dateFormat = dateFormat
            var firstLine = "Log file - " + format.string(from: Date()) + "App version -*" + verFull() + "*-\n"
            firstLine += "iOS - \(UIDevice.current.name) \(device.systemName) \(device.systemVersion)\n"
            if !subTitleLogFile.isEmpty {
                firstLine += subTitleLogFile + "\n"
            }
            log = firstLine + log
            do {
                try log.write(to: path, atomically: true, encoding: .utf8)
                if lastFile != path {
                    lastFiles.append(path)
                    lastFile = path
                    if lastFiles.count > countLogFiles, let firstPath = lastFiles.first {
                        deleteLogFile(url: firstPath)
                        lastFiles.removeFirst()
                    }
                }
            } catch {
                print("ERROR Logger - ", error.localizedDescription)
                if !isShowAlert {
                    isShowAlert = true
                    showAlert(title: "Log file not writed", message: String(describing: error))
                }
            }
        }
    }
    
    public func getLogFiles() {
        do {
            let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let array = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.fileAllocatedSizeKey], options: .skipsHiddenFiles).filter { $0.pathExtension == "txt" && $0.path.contains("\(logFileName)-") }
            lastFiles = array.sorted { urlSearchDate($0) < urlSearchDate($1) }
            //            print("Last File - ", lastFiles)
            for i in 0...lastFiles.count where i < (lastFiles.count - countLogFiles) {
                deleteLogFile(url: lastFiles[i])
                lastFiles.remove(at: i)
            }
        } catch {
            print("ERROR Logger - ", error.localizedDescription)
        }
    }
    
    public func deleteLogFile(all: Bool = true) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: path.path) {
            do {
                try FileManager.default.trashItem(at: path, resultingItemURL: nil)
            } catch {
                print("ERROR Logger - ", error.localizedDescription)
            }
        }
    }
    
    public func deleteLogFile(url: URL) {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.trashItem(at: url, resultingItemURL: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func uploadLogFiles() {
        if !lastFiles.isEmpty {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(emails)
                mail.setSubject(lastFiles[0].lastPathComponent)
                let device = UIDevice.current
                var body = "Please see attached\n"
                emails.forEach { body += $0 + "\n" }
                body += "\n"
                body += "\(device.name) \(device.systemName) \(device.systemVersion)"
                mail.setMessageBody(body, isHTML: false)
                var i = 0
                while i < lastFiles.count {
                    if let fileData = NSData(contentsOfFile: lastFiles[i].path) {
                        mail.addAttachmentData(fileData as Data, mimeType: "text/txt", fileName: lastFiles[i].lastPathComponent)
                    }
                    if i < lastFiles.count, i < countLogFiles {
                        i += 1
                    } else {
                        break
                    }
                }
                let vc = topMostViewController()
                vc?.present(mail, animated: true, completion: nil)
            }
        } else {
            showAlert(title: "Error", message: "Log File not found")
        }
    }
}

private extension ShtLogger {
    func urlSearchDate(_ url: URL) -> Date {
        let formater = DateFormatter()
        formater.timeZone = TimeZone(secondsFromGMT: 0)
        formater.dateFormat = fileDateFormat
        let suf = url.lastPathComponent.suffix(17)
        let pref = suf.prefix(13)
        //        print(url.lastPathComponent, "===", formater.date(from: String(pref)) as Any)
        return formater.date(from: String(pref)) ?? Date()
    }
    
    func showAlert(title: String, message: String) {
        guard let vc = topMostViewController() else { return }
        var alert = UIAlertController()
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    func topMostViewController() -> UIViewController? {
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return topMostVC(keyWindow?.rootViewController)
        } else {
            return topMostVC(UIApplication.shared.keyWindow?.rootViewController)
        }
    }
    
    func topMostVC(_ controller: UIViewController?) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topMostVC(navigationController.topViewController)
        } else if let tabBarController = controller as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return topMostVC(selectedViewController)
            }
            return topMostVC(tabBarController)
        } else if let presentedViewController = controller?.presentedViewController {
            return topMostVC(presentedViewController)
        } else {
            return controller
        }
    }
    
    func verFull() -> String {
        if let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String, let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            return versionNumber + "." + buildNumber
        } else {
            return "unknown"
        }
    }
}

extension ShtLogger: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
