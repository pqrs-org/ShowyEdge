VERSION = `head -n 1 version`

all:
	$(MAKE) gitclean
	./make-package.sh

build:
	$(MAKE) -C src

clean-launch-services-database:
	bash scripts/clean-launch-services-database.sh

clean:
	$(MAKE) -C src clean
	rm -f *.dmg

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

swift-format:
	find src -name '*.swift' -print0 | xargs -0 swift-format -i
