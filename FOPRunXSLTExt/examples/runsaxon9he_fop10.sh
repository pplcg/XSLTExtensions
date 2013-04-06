#!/bin/bash

SAXON=/home/arvedhs/Development/JavaLibs/saxon9he.jar
FOP=/home/arvedhs/Development/XSLFO/fop-1.0
CP=$SAXON:$FOP/build/fop.jar
CP=$CP:$FOP/lib/xmlgraphics-commons-1.4.jar
CP=$CP:$FOP/lib/commons-logging-1.0.4.jar
CP=$CP:$FOP/lib/commons-io-1.3.1.jar
CP=$CP:$FOP/lib/avalon-framework-4.2.0.jar
CP=$CP:$FOP/lib/batik-all-1.7.jar
CP=$CP:~/Development/NetBeansProjects/FOPRunXSLTExt/dist/FOPRunXSLTExt.jar

java -cp $CP net.sf.saxon.Transform -init:org.w3c.ppl.xslt.ext.fop.saxon.RunFOPExtInitializer -s:$1 -xsl:$2 -o:$3 dest_dir=$4 area_tree_filename=$5