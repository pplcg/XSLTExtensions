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
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

// Allgemeine Informationen über eine Assembly werden über die folgenden 
// Attribute gesteuert. Ändern Sie diese Attributwerte, um die Informationen zu ändern,
// die mit einer Assembly verknüpft sind.
[assembly: AssemblyTitle("pi.ep.ppl.xslt.ext.fop.dotnet")]
[assembly: AssemblyDescription("")]
[assembly: AssemblyConfiguration("")]
[assembly: AssemblyCompany("")]
[assembly: AssemblyProduct("pi.ep.ppl.xslt.ext.fop.dotnet")]
[assembly: AssemblyCopyright("Copyright ©  2014")]
[assembly: AssemblyTrademark("")]
[assembly: AssemblyCulture("")]

// Durch Festlegen von ComVisible auf "false" werden die Typen in dieser Assembly unsichtbar 
// für COM-Komponenten. Wenn Sie auf einen Typ in dieser Assembly von 
// COM zugreifen müssen, legen Sie das ComVisible-Attribut für diesen Typ auf "true" fest.
[assembly: ComVisible(false)]

// Die folgende GUID bestimmt die ID der Typbibliothek, wenn dieses Projekt für COM verfügbar gemacht wird
[assembly: Guid("1090c78a-8949-4d12-ab9f-3f3a867e0882")]

// Versionsinformationen für eine Assembly bestehen aus den folgenden vier Werten:
//
//      Hauptversion
//      Nebenversion 
//      Buildnummer
//      Revision
//
// Sie können alle Werte angeben oder die standardmäßigen Build- und Revisionsnummern 
// übernehmen, indem Sie "*" eingeben:
// [assembly: AssemblyVersion("1.0.*")]
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]
