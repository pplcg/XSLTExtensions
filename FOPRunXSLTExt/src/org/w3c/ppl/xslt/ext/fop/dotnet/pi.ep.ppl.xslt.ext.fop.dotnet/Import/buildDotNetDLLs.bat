echo IKVM dir: %1
echo JAR dir : %2
echo outfile : %3
%~p1%~n1\ikvmc.exe -target:library -reference:IKVM.OpenJDK.Core.dll -recurse:%~p2%~n2\*.jar -version:1.1 -out:%3