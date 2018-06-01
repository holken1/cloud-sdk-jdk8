# cloud-sdk-jdk8

When deploying Java 8 webapps to Google App Engine standard environment (on Google Cloud Platform), I ran into issues when using the Google-provided Docker image `google/cloud-sdk:latest` as it contains only Java 7 and I got error messages related to compiling the JSP files upon deploy (see below).

Installing the OpenJDK v8 in the image solves the issue. This is done using the `jessie-backports` repo as Google's image builds upon Debian Jessie. The results is an image that can deploy java 8 webapps with JSPs without any issues. (It might struggle with Java 7 apps though!)

Just use this image as a drop-in replacement of `google/cloud-sdk:latest`

# Sample error messages with original image

```
Beginning interaction for module default...
0% Scanning for jsp files.
0% Compiling jsp files.
Jun 01, 2018 10:50:37 AM org.apache.jasper.servlet.TldScanner scanJars
INFO: At least one JAR was scanned for TLDs yet contained no TLDs. Enable debug logging for this logger for a complete list of JARs that were scanned but no TLDs were found in them. Skipping unneeded JARs during scanning can improve startup time and JSP compilation time.
Jun 01, 2018 10:50:37 AM org.apache.jasper.JspC processFile
INFO: Built File: /test.jsp
Jun 01, 2018 10:50:37 AM org.apache.jasper.JspC processFile
INFO: Built File: /index.jsp
Unable to stage app: invalid source release: 8
Please see the logs [/tmp/appcfg6827028787336986659.log] for further information.
------------------------------------ STDERR ------------------------------------
Jun 01, 2018 10:50:35 AM java.util.prefs.FileSystemPreferences$1 run
INFO: Created user preferences directory.
--------------------------------------------------------------------------------

cat /tmp/appcfg6827028787336986659.log
Unable to stage:
java.lang.IllegalArgumentException: invalid source release: 8
	at com.sun.tools.javac.main.RecognizedOptions$GrumpyHelper.error(RecognizedOptions.java:88)
	at com.sun.tools.javac.main.RecognizedOptions$9.process(RecognizedOptions.java:348)
	at com.sun.tools.javac.api.JavacTool.processOptions(JavacTool.java:242)
	at com.sun.tools.javac.api.JavacTool.getTask(JavacTool.java:199)
	at com.sun.tools.javac.api.JavacTool.getTask(JavacTool.java:68)
	at com.google.appengine.tools.admin.Application.compileJspJavaFiles(Application.java:1318)
	at com.google.appengine.tools.admin.Application.compileJsps(Application.java:1264)
	at com.google.appengine.tools.admin.Application.populateStagingDirectory(Application.java:975)
	at com.google.appengine.tools.admin.Application.createStagingDirectory(Application.java:872)
	at com.google.appengine.tools.admin.AppAdminImpl.stageApplication(AppAdminImpl.java:539)
	at com.google.appengine.tools.admin.AppAdminImpl.stageApplicationWithDefaultResourceLimits(AppAdminImpl.java:492)
	at com.google.appengine.tools.admin.AppCfg$StagingAction.execute(AppCfg.java:2529)
	at com.google.appengine.tools.admin.AppCfg.executeAction(AppCfg.java:390)
	at com.google.appengine.tools.admin.AppCfg.<init>(AppCfg.java:213)
	at com.google.appengine.tools.admin.AppCfg.<init>(AppCfg.java:119)
	at com.google.appengine.tools.admin.AppCfg.main(AppCfg.java:115)
com.google.appengine.tools.admin.AdminException: Unable to stage app: invalid source release: 8
	at com.google.appengine.tools.admin.AppAdminImpl.stageApplication(AppAdminImpl.java:543)
	at com.google.appengine.tools.admin.AppAdminImpl.stageApplicationWithDefaultResourceLimits(AppAdminImpl.java:492)
	at com.google.appengine.tools.admin.AppCfg$StagingAction.execute(AppCfg.java:2529)
	at com.google.appengine.tools.admin.AppCfg.executeAction(AppCfg.java:390)
	at com.google.appengine.tools.admin.AppCfg.<init>(AppCfg.java:213)
	at com.google.appengine.tools.admin.AppCfg.<init>(AppCfg.java:119)
	at com.google.appengine.tools.admin.AppCfg.main(AppCfg.java:115)
Caused by: java.lang.IllegalArgumentException: invalid source release: 8
	at com.sun.tools.javac.main.RecognizedOptions$GrumpyHelper.error(RecognizedOptions.java:88)
	at com.sun.tools.javac.main.RecognizedOptions$9.process(RecognizedOptions.java:348)
	at com.sun.tools.javac.api.JavacTool.processOptions(JavacTool.java:242)
	at com.sun.tools.javac.api.JavacTool.getTask(JavacTool.java:199)
	at com.sun.tools.javac.api.JavacTool.getTask(JavacTool.java:68)
	at com.google.appengine.tools.admin.Application.compileJspJavaFiles(Application.java:1318)
	at com.google.appengine.tools.admin.Application.compileJsps(Application.java:1264)
	at com.google.appengine.tools.admin.Application.populateStagingDirectory(Application.java:975)
	at com.google.appengine.tools.admin.Application.createStagingDirectory(Application.java:872)
	at com.google.appengine.tools.admin.AppAdminImpl.stageApplication(AppAdminImpl.java:539)
	... 6 more
```
