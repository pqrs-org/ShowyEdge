all:
	$(MAKE) gitclean
	./make-package.sh

notarize:
	./scripts/notarize-app.sh

staple:
	xcrun stapler staple *.dmg

build:
	$(MAKE) -C src

clean:
	$(MAKE) -C src clean
	rm -f *.dmg

gitclean:
	git clean -f -x -d

swift-format:
	find src -name '*.swift' -print0 | xargs -0 swift-format -i
