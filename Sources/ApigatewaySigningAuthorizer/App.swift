import Foundation
import SwiftAWS
import VaporLambdaAdapter



public class App {

    public class func go() throws {
        let logger = LambdaLogger()
        logger.info("starting app")
        let app = AWSApp()
        try app.run()
    }
    
}
