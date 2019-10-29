---
unless_exists: true
to: Sources/<%=locals.feature%>/<%=locals.feature%>Models.swift
sh: swift package generate-xcodeproj
---
import Foundation
