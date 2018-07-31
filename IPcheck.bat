set addr=%1

ping %addr%
mstsc /v %addr%
"C:\Program Files (x86)\Internet Explorer\iexplore.exe" %addr%