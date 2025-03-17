sdkroot=c:\users\u8006988\garminSDK
projectroot=c:\users\u8006988\projects\oura
build :
	$(sdkroot)\bin\monkeyc  -y $(sdkroot)\keys\developer_key.der -o $(projectroot)\oura.prg -f $(projectroot)\monkey.jungle 

all: build
	$(sdkroot)\bin\connectiq
	$(sdkroot)\bin\monkeydo $(projectroot)\oura.prg fr735xt

rerun:	
	$(sdkroot)\bin\monkeydo $(projectroot)\oura.prg fr735xt
