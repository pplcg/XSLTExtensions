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
using System.IO;
using java.io;
using System.Xml.XPath;
using System.Xml;

namespace pi.ep.ppl.xslt.ext.fop.dotnet.Extensions
{
    /// <summary>
    /// Extension methods to enhance java.io.ByteArryOutputStream for conversion to DotNet data types
    /// </summary>
    public static class ByteArrayOutputStreamExtensions
    {
        /// <summary>
        /// Convert ByteArrayOutputStream to System.Xml.XPath.XPathDocument
        /// </summary>
        /// <param name="self">ByteArrayOutputStream object</param>
        /// <returns>XPathDocument converted from ByteArrayOutputStream</returns>
        public static XPathDocument ToXPathDocument(this ByteArrayOutputStream self)
        {
            XPathDocument doc = null;
            using (MemoryStream resultStream = new MemoryStream(self.toByteArray()))
            {
                using (XmlReader reader = XmlReader.Create(resultStream))
                {
                    doc = new XPathDocument(reader);
                }
            }
            return doc;
        }
    }
}
