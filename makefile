#Directory for packages
PKGDIR=debs/
#Default info file, located in packages directory
DEFINFO=Info.txt
#Package-specific info file, located in [PKGDIR]/[PACKAGE_NAME]/
PKGINFO=PackageInfo.txt
#Version-specific info file, located in [PKGDIR]/[PACKAGE_NAME]/[VERSION]/
VERINFO=VersionInfo.txt


Packages.bz2: $(PKGDIR)*/*/*.deb $(PKGDIR)$(DEFINFO) $(PKGDIR)*/$(PKGINFO) $(PKGDIR)*/*/$(VERINFO)
	make $(addsuffix .Package,$(dir $(filter %.deb,$^)))
	cat $(addsuffix .Package,$(dir $(filter %.deb,$^))) | bzip2 -kf > $@

.SECONDARY:
$(PKGDIR)%/.Package: $(PKGDIR)%/$(VERINFO) $(PKGDIR)%/../$(PKGINFO) $(PKGDIR)$(DEFINFO)
	cat $^ $$(printf "\n") | awk '!seen[$$1]++' | sort > $@

$(PKGDIR)$(DEFINFO):
	printf "Author: \nMaintainer: \n" > $@

$(PKGDIR)%/$(PKGINFO):
	printf "Package: \nArchitecture: iphoneos-arm\nDepends: \nName: %s\nSection: \nDescription: \n" $$(echo $* | cut -f1 -d /) > $@

$(PKGDIR)%/$(VERINFO): $(PKGDIR)%/*.deb
	printf "Version: $(*F)\nFilename: $<\nSize: %s\nMD5sum: %s\nSHA1: %s\nSHA256: %s\n\n" $$(stat -f%z $<) $$(md5 -q $<) $$(shasum $< | cut -f1 -d " ") $$(shasum -a 256 $< | cut -f1 -d " ") > $@