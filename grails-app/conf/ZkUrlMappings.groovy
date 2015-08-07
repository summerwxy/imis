class ZkUrlMappings {

    static excludes = ['/zkau/*', '/zkcomet/*'
        , "/upload/*", "/upload/*/*"
        , "/2014blessing/*", "/bootstrap/*"
        , "/bootstrap-colorpalette/*", "/bootstrap-datetimepicker/*" 
        , "/bower_components/*", "/dropzone/*"
        , "/themes/*", "/BigWheel/*", '/mooncake/*'
        ]

    static mappings = {

    	// "/$controller/$action?/$id?"{ // change from 2.3.5
        "/$controller/$action?/$id?(.$format)?"{
			constraints {
				// apply constraints here
			}
		}
		"/"(view:"/sys/home")
		"500"(view:'/error')
    }

}
