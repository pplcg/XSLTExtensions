/*
Program Name:                                                     
	pi.ep.ppl.xslt.ext.fop.dotnet.transformer

Requires:
    DotNet 4.0
    IKVM - http://www.ikvm.net/
    Apache FOP - http://xmlgraphics.apache.org/fop/
    FOP 1.1 must be compiled with IKVM (see Import/README
    
General Description:                                              
    DotNet XSLT-Processor Extension for FOP areaTree function support
    based on the Java implementation of Print and Page Layout Community Group @ W3C
    See http://www.w3.org/community/ppl/wiki/FOPRunXSLTExt
License: 
    W3C license
Author: 
	Markus Wiedenmaier
    practice innovatio
    Zum Kiesgrüble 20
    DE-78259 Mühlhausen-Ehingen
    mailto:info@practice-innovation.de
    http://www.practice-innovation.de
Versions:
    0.1 2014-02-28 Markus Wiedenmaier
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using pi.ep.xslt.ext.interfaces;
using System.Xml.XPath;
using org.apache.fop.apps;

using javax.xml.transform;
using org.apache.xalan.processor;
using javax.xml.transform.sax;
using javax.xml.transform.dom;
using org.xml.sax;
using java.io;
using System.IO;
using System.Xml;
using javax.xml.transform.stream;
using pi.ep.ppl.xslt.ext.fop.dotnet.Extensions;

namespace pi.ep.ppl.xslt.ext.fop.dotnet
{
    public class RunFOP : IXsltExtensionObject
    {
        /// <summary>
        /// Get the Area Tree from Antenna House Formatter
        /// </summary>
        /// <param name="nav">XSL:FO tree</param>
        /// <returns></returns>
        public XPathNavigator areaTree(XPathNavigator nav)
        {
            XPathDocument doc = GetAreaTrea(nav, string.Empty);
            return doc.CreateNavigator();
        }
        /// <summary>
        /// Get the Area Tree from Antenna House Formatter
        /// </summary>
        /// <param name="nav">XSL:FO tree</param>
        /// <param name="optionFileName">Option file name: Setting file for Antenna House Formatter rendering</param>
        /// <returns></returns>
        public XPathNavigator areaTree(XPathNavigator nav, string optionFileName)
        {
            XPathDocument doc = GetAreaTrea(nav, optionFileName);
            return doc.CreateNavigator();
        }
        /// <summary>
        /// Get the Area Tree from Antenna House Formatter
        /// </summary>
        /// <param name="nav">XSL:FO tree</param>
        /// <param name="configFileName">FOP configuration file name: Setting file for Antenna House Formatter rendering</param>
        /// <returns></returns>
        protected XPathDocument GetAreaTrea(XPathNavigator nav, string configFileName)
        {
            return GetAreaTrea(nav.ToJavaInputStream(), configFileName);
        }
        /// <summary>
        /// Get the Area Tree from Antenna House Formatter
        /// </summary>
        /// <param name="inputStream">XSL:FO tree as ByteArryInputStream</param>
        /// <param name="configFileName">FOP configuration file name: Setting file for Antenna House Formatter rendering</param>
        /// <returns></returns>
        protected XPathDocument GetAreaTrea(ByteArrayInputStream inputStream, string configFileName)
        {
            ByteArrayOutputStream outStream = new ByteArrayOutputStream();

            FOUserAgent userAgent = new FOUserAgent(FopFactory.newInstance());
            FopFactoryConfigurator configurator = new FopFactoryConfigurator(userAgent.getFactory());
            if (string.IsNullOrEmpty(configFileName)==false)
                userAgent.getFactory().setUserConfig(configFileName);
            Fop fop = userAgent.getFactory().newFop(MimeConstants.__Fields.MIME_FOP_AREA_TREE, userAgent, outStream);
            TransformerFactory tf = new TransformerFactoryImpl();
            Transformer transformer = tf.newTransformer();
            Source src = new StreamSource(inputStream);
            Result res = new SAXResult(fop.getDefaultHandler());
            transformer.transform(src, res);

            return outStream.ToXPathDocument();
        }
        #region IXsltExtensionObject implementation
        /// <summary>
        /// returns namespace used for running this extension object
        /// </summary>
        public string NamespaceURI
        {
            get
            {
                return "pi.ep.ppl.xslt.ext.fop.dotnet";
            }
        }
        #endregion
    }
}
