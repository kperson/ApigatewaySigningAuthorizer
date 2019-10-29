---
unless_exists: true
to: Sources/<%=locals.feature%>/<%=locals.feature%>DynamoHandler.swift
---
import Foundation
import SwiftAWS
import NIO

class <%=locals.feature%>DynamoHandler {
}

extension AWSApp {

    func setupDynamo<%=locals.feature%>(handler: <%=locals.feature%>DynamoHandler) {
        //Auto-generated
    }

}
