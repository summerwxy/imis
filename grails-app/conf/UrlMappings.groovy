class UrlMappings {
    static excludes = ["/upload/*", "/upload/*/*"]

	static mappings = {
		// "/$controller/$action?/$id?"{ // change from 2.3.5
        "/$controller/$action?/$id?(.$format)?"{
			constraints {
				// apply constraints here
			}
		}
		// "/"(view:"/sys/home")
        "/" (controller: 'sys', action: 'home')
		"500"(view:'/error')
	}
}
