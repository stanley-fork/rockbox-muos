## Make sure to place gptokeyb2 (arm64) binary in packaging/retro-handheld

RH_PACK_DIR=$(ROOTDIR)/packaging/retro-handheld
RH_PKG_DIR=pkgbuild
RH_ROCKBOX_DIR=$(RH_PKG_DIR)/rockbox

MUOS_PKG_DIR=$(RH_PKG_DIR)/muos
NEXTUI_PKG_DIR=$(RH_PKG_DIR)/nextui

rhbuild:
	mkdir $(RH_PKG_DIR)
	make PREFIX=$(RH_PKG_DIR)/build fullinstall
	mkdir $(RH_ROCKBOX_DIR)
	## Organize files
	mv $(RH_PKG_DIR)/build/bin/rockbox $(RH_ROCKBOX_DIR)
	mv $(RH_PKG_DIR)/build/lib/rockbox/* $(RH_ROCKBOX_DIR)
	mv $(RH_PKG_DIR)/build/share/rockbox/* $(RH_ROCKBOX_DIR)
	## Plugin workarounds
	mkdir $(RH_ROCKBOX_DIR)/rocks.data
	mv $(RH_ROCKBOX_DIR)/rocks/games/.picross $(RH_ROCKBOX_DIR)/rocks.data/.picross
	## Permissions
	chmod +x $(RH_ROCKBOX_DIR)/rockbox
	## Copy licenses over
	cp -R $(RH_PACK_DIR)/licenses $(RH_ROCKBOX_DIR) 
	rm -rf $(RH_PKG_DIR)/build

muos: 
	mkdir -p $(MUOS_PKG_DIR)/Rockbox
	cp -R $(RH_ROCKBOX_DIR)/* $(MUOS_PKG_DIR)/Rockbox
	## Copy muOS specific files
	cp $(RH_PACK_DIR)/rockbox.gptk $(MUOS_PKG_DIR)/Rockbox
	cp $(RH_PACK_DIR)/mux_launch.sh $(MUOS_PKG_DIR)/Rockbox
	## Permissions
	chmod +x $(MUOS_PKG_DIR)/Rockbox/mux_launch.sh

muosclean:
	rm -rf $(MUOS_PKG_DIR)

muos-zip: muosclean muos
	(cd $(MUOS_PKG_DIR) && zip -q -r - .) >Rockbox.muxapp

nextui:
	mkdir -p $(NEXTUI_PKG_DIR)
	cp -R $(RH_ROCKBOX_DIR) $(NEXTUI_PKG_DIR)
	mv $(NEXTUI_PKG_DIR)/rockbox/licenses $(NEXTUI_PKG_DIR)
	## Copy NextUI specific files
	cp $(RH_PACK_DIR)/rockbox.gptk $(NEXTUI_PKG_DIR)
	cp $(RH_PACK_DIR)/gptokeyb2 $(NEXTUI_PKG_DIR)
	cp $(RH_PACK_DIR)/gamecontrollerdb.txt $(NEXTUI_PKG_DIR)
	cp $(RH_PACK_DIR)/pak.json $(NEXTUI_PKG_DIR)
	cp $(RH_PACK_DIR)/launch.sh $(NEXTUI_PKG_DIR)
	## Permissions
	chmod +x $(NEXTUI_PKG_DIR)/gptokeyb2
	chmod +x $(NEXTUI_PKG_DIR)/launch.sh

nextuiclean:
	rm -rf $(NEXTUI_PKG_DIR)

nextui-zip: nextuiclean nextui
	(cd $(NEXTUI_PKG_DIR) && zip -q -r - .) >Rockbox.pak.zip

rhclean:
	rm -rf $(RH_PKG_DIR)/rockbox

