GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean

SDPLUGINDIR=./com.prolix.hwinfo.sdPlugin

PROTOS=$(wildcard ./*/**/**/*.proto)
PROTOPB=$(PROTOS:.proto=.pb.go)

plugin: proto
	$(GOBUILD) -o $(SDPLUGINDIR)/hwinfo.exe ./cmd/hwinfo_streamdeck_plugin
	$(GOBUILD) -o $(SDPLUGINDIR)/hwinfo-plugin.exe ./cmd/hwinfo-plugin
	cp ../go-hwinfo-hwservice-plugin/bin/hwinfo-plugin.exe $(SDPLUGINDIR)/hwinfo-plugin.exe

proto: $(PROTOPB)

$(PROTOPB): $(PROTOS)
	.cache/protoc/bin/protoc \
 		--go_out=Mgrpc/service_config/service_config.proto=/internal/proto/grpc_service_config:. \
		--go-grpc_out=Mgrpc/service_config/service_config.proto=/internal/proto/grpc_service_config:. \
  		--go_opt=paths=source_relative \
		--go-grpc_opt=paths=source_relative \
		$(<)

# plugin:
# 	-@kill-streamdeck.bat
# 	@go build -o com.prolix.hwinfo.sdPlugin\\hwinfo.exe github.com/prolix-oc/hwinfo-streamdeck/cmd/hwinfo_streamdeck_plugin
# 	@xcopy com.prolix.hwinfo.sdPlugin $(APPDATA)\\Elgato\\StreamDeck\\Plugins\\com.prolix.hwinfo.sdPlugin\\ /E /Q /Y
# 	@start-streamdeck.bat

debug:
	$(GOBUILD) -o $(SDPLUGINDIR)/hwinfo.exe ./cmd/hwinfo_debugger
	cp ../go-grpc-hardware-service/bin/hwinfo-plugin.exe $(SDPLUGINDIR)/hwinfo-plugin.exe
	-@install-plugin.bat
# @xcopy com.prolix.hwinfo.sdPlugin $(APPDATA)\\Elgato\\StreamDeck\\Plugins\\com.prolix.hwinfo.sdPlugin\\ /E /Q /Y

release:
	-@rm build/com.prolix.hwinfo.streamDeckPlugin
	@DistributionTool.exe -b -i com.prolix.hwinfo.sdPlugin -o build
