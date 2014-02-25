cd "%~d0%~p0..\bin"
echo xmlinfile %1
echo xslt stylesheet: %2
echo outfile %3
"%~d0%~p0..\bin\pi.ep.ppl.xslt.ext.ahf.dotnet.transformer.exe" %1 %2 %3 ppl-formatter=ahf
