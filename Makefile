%.pdf: %.md
	pandoc $(PANDOC_OPTS) --output=$@ $<
