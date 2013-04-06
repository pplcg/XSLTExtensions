#!/bin/bash

FOP=/home/arvedhs/Development/XSLFO/fop-1.0
CP=$FOP/build/fop.jar
CP=$CP:$FOP/lib/xalan-2.7.0.jar
CP=$CP:$FOP/lib/xercesImpl-2.7.1.jar
CP=$CP:$FOP/lib/xml-apis-1.3.04.jar
CP=$CP:$FOP/lib/serializer-2.7.0.jar
CP=$CP:$FOP/lib/xmlgraphics-commons-1.4.jar
CP=$CP:$FOP/lib/commons-logging-1.0.4.jar
CP=$CP:$FOP/lib/commons-io-1.3.1.jar
CP=$CP:$FOP/lib/avalon-framework-4.2.0.jar
CP=$CP:$FOP/lib/batik-all-1.7.jar
CP=$CP:~/Development/NetBeansProjects/FOPRunXSLTExt/dist/FOPRunXSLTExt.jar

java -cp $CP org.apache.xalan.xslt.Process -IN $1 -XSL $2 -OUT $3 -PARAM dest_dir $4 -PARAM area_tree_filename $5
