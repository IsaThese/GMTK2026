# project name
NAME=gmtk-2026
# paths to godot and butler executables
GODOT=$(HOME)/bin/godot
BUTLER=$(HOME)/bin/butler
# paths to project source and project build folder
PROJECT=.
OUT=$(HOME)/bin/$(NAME)
# itch.io URL for publishing builds
ITCH_URL=zeroji/$(NAME)

SCENES=$(shell find -name '*.tscn')

all: html windows linux
html: $(OUT)/$(NAME)_html.zip
windows: $(OUT)/$(NAME)_win.zip
linux: $(OUT)/$(NAME)_linux.zip

$(OUT)/$(NAME)_html.zip: $(SCENES)
	@mkdir -p $(OUT)/html
	$(GODOT) --headless --path $(PROJECT) --export-release "Web" $(OUT)/html/index.html
	zip -jr $@ $(OUT)/html/index.*

$(OUT)/$(NAME)_win.zip: $(SCENES)
	$(GODOT) --headless --path $(PROJECT) --export-release "Windows Desktop" $(OUT)/$(NAME).exe
	zip -jr $@ $(OUT)/$(NAME).exe $(OUT)/$(NAME).pck

$(OUT)/$(NAME)_linux.zip: $(SCENES)
	$(GODOT) --headless --path $(PROJECT) --export-release "Linux" $(OUT)/$(NAME).x86_64
	zip -jr $@ $(OUT)/$(NAME).x86_64 $(OUT)/$(NAME).pck

deploy: html
	scp $(OUT)/$(NAME)_html.zip stella:/tmp/
	ssh stella unzip -o /tmp/$(NAME)_html.zip -d play/$(NAME)/

publish_html: html
	$(BUTLER) push $(OUT)/$(NAME)_html.zip $(ITCH_URL):html
publish_windows: windows
	$(BUTLER) push $(OUT)/$(NAME)_win.zip $(ITCH_URL):windows
publish_linux: linux
	$(BUTLER) push $(OUT)/$(NAME)_linux.zip $(ITCH_URL):linux
publish_all: publish_html publish_windows publish_linux

clean:
	rm $(OUT)/$(NAME)_*.zip
	rm $(OUT)/$(NAME).*
	rm $(OUT)/html/index.*
