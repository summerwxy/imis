grails.servlet.version = "3.0" // Change depending on target container compliance (2.5 or 3.0)
grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.work.dir = "target/work"
grails.project.target.level = 1.6
grails.project.source.level = 1.6
//grails.project.war.file = "target/${appName}-${appVersion}.war"
/*
grails.project.fork = [
    // configure settings for compilation JVM, note that if you alter the Groovy version forked compilation is required
    //  compile: [maxMemory: 256, minMemory: 64, debug: false, maxPerm: 256, daemon:true],

    // configure settings for the test-app JVM, uses the daemon by default
    test: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256, daemon:true],
    // configure settings for the run-app JVM
    run: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256, forkReserve:false],
    // configure settings for the run-war JVM
    war: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256, forkReserve:false],
    // configure settings for the Console UI JVM
    console: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256]
]
*/

// grails.project.dependency.resolver = "maven" // or ivy
grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // specify dependency exclusions here; for example, uncomment this to disable ehcache:
        // excludes 'ehcache'
    }
    log "error" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    checksums true // Whether to verify checksums on resolve
    legacyResolve true // whether to do a secondary resolve on plugin installation, not advised and here for backwards compatibility

    repositories {
        inherits true // Whether to inherit repository definitions from plugins

        grailsPlugins()
        grailsHome()
        grailsCentral()

        mavenLocal()
        mavenCentral()

        // mavenLocal "${PATH}"
        flatDir name:'myRepo', dirs:'lib'

        // uncomment these (or add new ones) to enable remote dependency resolution from public Maven repositories
        //mavenRepo "http://snapshots.repository.codehaus.org"
        //mavenRepo "http://repository.codehaus.org"
        //mavenRepo "http://download.java.net/maven/2/"
        //mavenRepo "http://repository.jboss.com/maven2/"
    }
    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes eg.

        // runtime 'mysql:mysql-connector-java:5.1.20'
        runtime 'net.sourceforge.jtds:jtds:1.3.1'
        runtime 'com.belerweb:pinyin4j:2.5.0'
        runtime 'org.igniterealtime.smack:smack:3.2.1'
        runtime 'org.igniterealtime.smack:smackx:3.2.1'
        runtime 'org.beanshell:bsh:2.0b5'
        runtime 'dom4j:dom4j:1.6.1'
        runtime 'commons-net:commons-net:3.3'
        //runtime 'https://java-zhconverter.googlecode.com/files/ZHConverter.jar'

        //runtime 'com.cloudhopper.proxool:proxool:0.9.1'
        //runtime 'org.xerial:sqlite-jdbc:3.7.15-M1'
        runtime 'net.sourceforge.jexcelapi:jxl:2.6.12'
        runtime 'me.chanjar:weixin-java-mp:1.2.0'
        runtime 'me.chanjar:weixin-java-cp:1.2.0'
        runtime "org.slf4j:slf4j-api:1.7.10"
        runtime "commons-io:commons-io:2.4"

        // weixin popular
        runtime 'com.alibaba:fastjson:1.2.0'
        runtime 'org.apache.httpcomponents:httpclient:4.3.5'
        runtime 'org.apache.httpcomponents:httpmime:4.3.4'
        runtime 'com.sun.xml.bind:jaxb-impl:2.1.13'

        // change default groovy version
        compile 'org.codehaus.groovy:groovy-all:2.2.2'
    }

    plugins {
        //runtime ":hibernate:$grailsVersion" // disable from 2.3.6
        runtime ':hibernate:3.6.10.13'
        runtime ":jquery:1.11.0.1"
        runtime ":resources:1.2.7"


        // Uncomment these (or add new ones) to enable additional resources capabilities
        //runtime ":zipped-resources:1.0"
        //runtime ":cached-resources:1.0"
        //runtime ":yui-minify-resources:0.1.4"

        //build ":tomcat:$grailsVersion" // disable from 2.3.6
        build ':tomcat:7.0.52.1'

        runtime ":database-migration:1.4.0"

        compile ':cache:1.1.5'
        compile ":zk:2.3.1" // ":zk:2.3.1" ":zk:2.1.0"
        compile ":quartz:1.0.1"
        // compile ":qrcode:0.6"

    }
}
