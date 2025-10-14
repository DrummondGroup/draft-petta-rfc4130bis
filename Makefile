LIBDIR := lib
include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update --init
else
ifneq (,$(wildcard $(ID_TEMPLATE_HOME)))
	ln -s "$(ID_TEMPLATE_HOME)" $(LIBDIR)
else
	git clone -q --depth 10 -b main \
	    https://github.com/martinthomson/i-d-template $(LIBDIR)
endif
endif

# This allows rebuilding even if no changes are detected

.PHONY: clean rebuild

# clean is probably already defined in lib/targets.mk, so we just
# declare it phony and define a "rebuild" wrapper.
rebuild: 
	@echo "Rebuilding draft from scratch..."
	$(MAKE) clean
	$(MAKE) all
