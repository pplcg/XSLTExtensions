cd "%~d0%~p0"
echo xmlinfile %1
echo xslt stylesheet: %2
echo outfile %3
pi.ep.xslt.transformer.app.exe %1 %2 %3 ppl-formatter=ahf
