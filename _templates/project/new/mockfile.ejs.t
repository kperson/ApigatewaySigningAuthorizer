---
to: Mockfile
unless_exists: true
---
sourceryCommand: null
<%=h.inflection.camelize(locals.name.replace(/-/g, '_'), false)%>Tests:
  sources:
    include:
    - ./Sources/<%=h.inflection.camelize(locals.name.replace(/-/g, '_'), false)%>
  output: ./Tests/<%=h.inflection.camelize(locals.name.replace(/-/g, '_'), false)%>Tests/Mock.generated.swift
  targets:
  - <%=h.inflection.camelize(locals.name.replace(/-/g, '_'), false)%>Tests
  testable:
  - <%=h.inflection.camelize(locals.name.replace(/-/g, '_'), false)%>
  import:
  - Foundation
  - NIO