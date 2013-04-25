@ECHO OFF

rem The current directory
set FOPRUNXSLTEXT_HOME=%~dp0

rem Saxon 9.4 or later jar file.  Modify as
rem necessary for location of Saxon jar on your
rem system.
set SAXON=C:\saxon\saxon9he.jar

rem Location of unzipped FOP 1.0 binary distribution.
set FOP_HOME=%~dp0\fop-1.0

rem Set the classpath for use by Java.
set CP=%SAXON%
set CP=%CP%;%FOP_HOME%\build\fop.jar
set CP=%CP%;%FOP_HOME%\lib\xmlgraphics-commons-1.4.jar
set CP=%CP%;%FOP_HOME%\lib\commons-logging-1.0.4.jar
set CP=%CP%;%FOP_HOME%\lib\commons-io-1.3.1.jar
set CP=%CP%;%FOP_HOME%\lib\avalon-framework-4.2.0.jar
set CP=%CP%;%FOP_HOME%\lib\batik-all-1.7.jar
set CP=%CP%;%FOP_HOME%\lib\serializer-2.7.0.jar
set CP=%CP%;%FOP_HOME%\lib\xalan-2.7.0.jar
set CP=%CP%;%FOP_HOME%\lib\xerxesImpl-2.7.1.jar
set CP=%CP%;%FOPRUNXSLTEXT_HOME%\FOPRunXSLTExt.jar

java -cp %CP% net.sf.saxon.Transform -init:org.w3c.ppl.xslt.ext.fop.saxon.RunFOPExtInitializer -s:%1 -xsl:%2 -o:%3 dest_dir=%4 area_tree_filename=%5
