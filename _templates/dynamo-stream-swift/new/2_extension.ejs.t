---
inject: true
to: Sources/<%=locals.feature%>/<%=locals.feature%>DynamoHandler.swift
after: //Auto-generated
skip_if: 'name: \"<%=locals.handler%>\"'
sh: swift package generate-xcodeproj
---
        addDynamoStream(
            name: "<%=locals.handler%>", 
            type: <%=locals.model%>.self, 
            caseSetting: nil, 
            handler: handler.handleStreamSortChange
        )
