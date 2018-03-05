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
using System.Xml.XPath;
using System.IO;
using System.Xml;

namespace pi.ep.ppl.xslt.ext.fop.dotnet.Extensions
{
    /// <summary>
    /// Extension methods to enhance System.Xml.XPath.XPathNavigator for conversion to Java Data Types
    /// </summary>
    public static class XPathNavigatorExtensions
    {
        /// <summary>
        /// Converts System.Xml.XPath.XPathNavigator to java.io.ByteArrayInputStream
        /// </summary>
        /// <param name="self">XPathNavigator object</param>
        /// <returns>java.io.ByteArrayInputStream converted from XPathNavigator</returns>
        public static java.io.ByteArrayInputStream ToJavaInputStream(this XPathNavigator self)
        {
            using (MemoryStream inStream = new MemoryStream())
            {
                using (XmlWriter writer = XmlWriter.Create(inStream))
                    self.WriteSubtree(writer);
                return new java.io.ByteArrayInputStream(inStream.GetBuffer());
            }
        }
    }
}
