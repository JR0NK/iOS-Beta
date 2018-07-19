PKGDIR=debs/

Packages.bzip2: $(PKGDIR)/*/.Package
	cat $^ | bzip2 -kf >> ./Packages.bz2

$(PKGDIR)%/.Package: (PKGDIR)/%/VersionInfo.txt $(PKGDIR)%/../PackageInfo.txt $(PKGDIR)Info.txt
	

$(PKGDIR)%/VersionInfo.txt: $(PKGDIR)%/*.deb
	printf "Version: $(patsubst '%/',,$*)\nFilename: $(<F)\nSize: %s\nMD5sum: %s\nSHA1: %s\nSHA256: %s\n" \$(stat -f%z $<) \$(md5 -q $<) \$(shasum $< | cut -f1 -d " ") \$(shasum -a 256 $< | cut -f1 -d " ") >> $@

$(PKGDIR)%/PackageInfo.txt:
	printf "Package: \nArchitecture: iphoneos-arm\nDepends: \nName: $*\nSection: \nDescription: \n" >> (PKGDIR)/%/PackageInfo.txt