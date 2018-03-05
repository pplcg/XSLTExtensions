@ECHO OFF

rem The current directory
set FOPRUNXSLTEXT_HOME=%~dp0

AHF61_64_HOME="AHFCmd.exe"
export AHF61_64_HOME

AHF61_64_LIB_FOLDER=${AHF61_64_HOME}/lib
AHF61_64_BIN_FOLDER=${AHF61_64_HOME}/bin
AHF61_64_ETC_FOLDER=${AHF61_64_HOME}/etc
AHF61_64_SDATA_FOLDER=${AHF61_64_HOME}/sdata

LD_LIBRARY_PATH=${AHF61_64_LIB_FOLDER}:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH

AHF61_64_LIC_PATH=${AHF61_64_ETC_FOLDER}
export AHF61_64_LIC_PATH

AHF61_64_HYPDIC_PATH=${AHF61_64_ETC_FOLDER}/hyphenation
export AHF61_64_HYPDIC_PATH

AHF61_64_DMC_TBLPATH=${AHF61_64_SDATA_FOLDER}/base2
export AHF61_64_DMC_TBLPATH

AHF61_64_DEFAULT_HTML_CSS=${AHF61_64_ETC_FOLDER}/html.css
export AHF61_64_DEFAULT_HTML_CSS

AHF61_64_FONT_CONFIGFILE=${AHF61_64_ETC_FOLDER}/font-config.xml
export AHF61_64_FONT_CONFIGFILE

rem Saxon 9.5 or later jar file.  Modify as
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

java -cp %CP% net.sf.saxon.Transform -init:org.w3c.ppl.xslt.ext.fop.saxon.RunFOPExtInitializer -s:%1 -xsl:%2 -o:%3 -it:main dest_dir=%4 area_tree_filename=%5
