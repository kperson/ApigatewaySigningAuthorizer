---
to: Sources/<%=h.inflection.camelize(locals.name.replace(/-/g, '_'), false)%>/App.swift%>
unless_exists: true
---
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