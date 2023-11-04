import Foundation
import ShtLogger

let logger = ShtLogger.shared

struct LoggerManager {
    func setDefault() {
        logger.logFileName = "ShtLogger Demo - iOS"
        logger.isNotSave = false
        logger.emails = ["shtroger@aol.com"]
        logger.subTitleLogFile = ""
        logger.dateFormat = "dd.MM.YYYY HH:mm:ss"
        logger.timeFormat = "[HH:mm:ss]"
        logger.countLogFiles = 5
        logger.uploadLogFiles()
    }
}
