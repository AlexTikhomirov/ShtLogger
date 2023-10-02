import XCTest
@testable import ShtLogger

final class ShtLoggerTests: XCTestCase {
    let logger = ShtLogger.shared
    
    func testDefaultValue() throws {
        print("************************* Default Values *************************")
        print("          Log file name - \(logger.logFileName)")
        print("          Not save - \(logger.isNotSave)")
        print("          Emails - \(logger.emails)")
        print("          SubTitle log file - \(logger.subTitleLogFile)")
        print("          Date format - \(logger.dateFormat)")
        print("          Time format - \(logger.timeFormat)")
        print("          Count log files - \(logger.countLogFiles)")
    }
    
    func testBuildVersion() throws {
        print("************************* APP Version *************************")
        let ver0 = ShtBuildVersion.verFull()
        var ver1 = ver0
        _ = String(ver1.removeLast())
        print("          APP Version - \(ver0)")
        XCTAssertTrue(ShtBuildVersion.checkVersion(ver0) == .actual, "Build Version isn't actual")
        XCTAssertTrue(ShtBuildVersion.checkVersion(ver1) == .early, "Build Version isn't early")
        XCTAssertTrue(ShtBuildVersion.checkVersion(ver0 + "1") == .latest, "Build Version isn't latest")
    }
    
    func testLogger() throws {
        print("************************* Logger *************************")
        ShtEventCommon.allCases.forEach { logger.log(event: $0) }
    }
}
