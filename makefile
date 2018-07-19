PKGDIR=debs/

Packages.bzip2: $(PKGDIR)/*/.Package
	cat $^ | bzip2 -kf >> ./Packages.bz2

$(PKGDIR)/%/.Package: (PKGDIR)/%/VersionInfo.txt $(PKGDIR)/%/../PackageInfo.txt $(PKGDIR)/Info.txt
	

$(PKGDIR)/%/VersionInfo.txt: $(PKGDIR)/%/*.deb
	printf "Version: $*\nFilename: $(<F)\Size: %s\nMD5sum: %s\nSHA1: %s\nSHA256: %s\n" >> (PKGDIR)/%/VersionInfo.txt

$(PKGDIR)/%/PackageInfo.txt:
	printf "Package: \nArchitecture: iphoneos-arm\nDepends: \nName: $*\nSection: \nDescription: \n" >> (PKGDIR)/%/PackageInfo.txt