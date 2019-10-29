---
to: Sources/<%=h.inflection.camelize(locals.name.replace(/-/g, '_'), false)%>App/main.swift%>
unless_exists: true
---
import Foundation
import <%=h.inflection.camelize(locals.name.replace(/-/g, '_'), false)%>

try App.go()