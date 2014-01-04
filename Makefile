DESTDIR ?=/usr/local

install:
	@echo "Installing into $(DESTDIR)"
	mkdir -p $(DESTDIR)/gnuplorer/output
	mkdir -p $(DESTDIR)/gnuplorer/bin
	mkdir -p $(DESTDIR)/gnuplorer/etc
	cp gnuplorer.sh $(DESTDIR)/gnuplorer/bin/
	cp gnuplorer.cfg $(DESTDIR)/gnuplorer/etc/
	chmod 744 $(DESTDIR)/gnuplorer/bin/gnuplorer.sh
	chmod 644 $(DESTDIR)/gnuplorer/etc/gnuplorer.cfg
	@echo "Install complete"

clean:
	rm -rf $(DESTDIR)/gnuplorer


