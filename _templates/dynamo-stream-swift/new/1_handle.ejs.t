---
inject: true
to: Sources/<%=locals.feature%>/<%=locals.feature%>DynamoHandler.swift
after: class <%=locals.feature%>DynamoHandler {
skip_if: func <%=locals.function_name%>\(event
---
    
    func <%=locals.function_name%>(event: GroupedRecords<LambdaExecutionContext, DynamoStreamRecordMeta, ChangeCapture<<%=locals.model%>>>) throws -> EventLoopFuture<Void> {
        //TODO: do work here
        return event.eventLoop.void()
    }
