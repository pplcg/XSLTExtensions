/*
Program Name:                                                     
	pi.ep.ppl.xslt.ext.ahf.dotnet.transformer

Requires:
    DotNet 4.0
    Antenna House Formatter 6.1 MR2a
    (How to fit dll link to another version, see app.config)
General Description:                                              
    DotNet XSLT-Processor Extension for Antenna House Formatter areaTree function support
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
    0.1 2014-02-14 Markus Wiedenmaier
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.XPath;
using System.Xml.Linq;
using XfoDotNetCtl;
using System.Xml;
using System.IO;
using pi.ep.xslt.ext.interfaces;

namespace pi.ep.ppl.xslt.ext.ahf.dotnet
{
    /// <summary>
    /// Implementation of Antenna House Formatter XSLT Extensions
    /// </summary>
    public class RunAHF : IXsltExtensionObject
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
        /// <param name="optionFileName">Option file name: Setting file for Antenna House Formatter rendering</param>
        /// <returns></returns>
        protected XPathDocument GetAreaTrea(XPathNavigator nav, string optionFileName)
        {
            XfoObj processor = null;
            try
            {
                processor = new XfoObj();
                processor.OnFormatPage += new XfoObj.FormatPageEventHandler(OnFormatPage); //returns GCHandle Exception, if loaded in AppDomain
                processor.OnRenderPage += new XfoObj.RenderPageEventHandler(OnRenderPage);
                if (optionFileName != string.Empty)
                    processor.OptionFileURI = optionFileName;
                XmlDocument doc = new XmlDocument();
                doc.LoadXml(nav.OuterXml);
                processor.XmlDomDocument = doc;
                processor.ExitLevel = 4;
                processor.PrinterName = "@AreaTree";
                using (MemoryStream outStream = new MemoryStream())
                {
                    processor.Render(doc, outStream, "@AreaTree");
                    outStream.Position = 0;
                    return new XPathDocument(outStream);
                }
            }
            catch (XfoException e)
            {
                Console.WriteLine(e.Message);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                throw e;
            }
            return null;
        }
        #region IXsltExtensionObject implementation
        /// <summary>
        /// returns namespace used for running this extension object
        /// </summary>
        public string NamespaceURI
        {
            get
            {
                return "pi.ep.ppl.xslt.ext.ahf.dotnet";
            }
        }
        #endregion
        /// <summary>
        /// Eventhandler for Antenna House Formatter event OnRenderPage
        /// </summary>
        /// <param name="pageNumber"></param>
        /// <param name="pageEmf"></param>
        /// <param name="pageWidth"></param>
        /// <param name="pageHeight"></param>
        /// <returns></returns>
        protected int OnRenderPage(int pageNumber, MemoryStream pageEmf, float pageWidth, float pageHeight)
        {
            string message = string.Format("AHF: rendering page {0}: width:{1} height: {2}", pageNumber, pageHeight, pageWidth);
            Console.WriteLine(message);
            return pageNumber;
        }
        /// <summary>
        /// Eventhandler for Antenna House Formatter event OnFormatPage
        /// </summary>
        protected virtual int OnFormatPage(int pageNumber)
        {
            string message = string.Format("AHF: formatting page {0}", pageNumber);
            Console.WriteLine(message);
            return pageNumber;
        }
    }
}
