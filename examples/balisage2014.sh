#!/bin/bash

# Pygments formatter for xsl-fo output
# https://bitbucket.org/sratcliffe/pygments-xslfo-formatter
pygmentize -f xslfo -l xml -O style=manni balisage2014.xml > balisage2014.xml.fo
pygmentize -f xslfo -l xslt -O style=manni balisage2014.xsl > balisage2014.xsl.fo


AHF61_64_HOME="/usr/AHFormatterV61_64"
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

SAXON=/usr/local/share/saxon/saxon9he.jar
AHF=/usr/AHFormatterV61_64/lib/XfoJavaCtl.jar
CP=$SAXON:/usr/AHFormatterV61_64/lib/XfoJavaCtl.jar
CP=$CP:/usr/local/src/pplcg/hg/FOPRunXSLTExt/dist/FOPRunXSLTExt.jar

java -cp $CP net.sf.saxon.Transform -init:org.w3c.ppl.xslt.ext.ahf.saxon.RunAHFExtInitializer -s:balisage2014.xml -xsl:balisage2014.xsl -o:balisage2014.fo -it:main  ppl-formatter=ahf pygmentize=yes

/usr/AHFormatterV61_64/run.sh -peb 1 -d balisage2014.fo -o out/balisage2014.pdf