VERSION = `head -n 1 version`

all:
	$(MAKE) gitclean
	$(MAKE) clean
	./make-package.sh
	$(MAKE) clean-launch-services-database

build:
	$(MAKE) -C src

clean:
	$(MAKE) -C src clean
	rm -f *.dmg

clean-launch-services-database:
	bash scripts/clean-launch-services-database.sh

gitclean:
	git clean -f -x -d

notarize:
	xcrun notarytool \
		submit ShowyEdge-$(VERSION).dmg \
		--keychain-profile "pqrs.org notarization" \
		--wait
	$(MAKE) staple
	say "notarization completed"

staple:
	xcrun stapler staple ShowyEdge-$(VERSION).dmg

check-staple:
	@xcrun stapler validate ShowyEdge-$(VERSION).dmg

swift-format:
	$(MAKE) -C src swift-format
