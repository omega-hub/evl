request_dependency(mvi)
request_dependency(porthole)
request_dependency(webView)

install(DIRECTORY . DESTINATION omegalib/evl PATTERN ".git" EXCLUDE)
