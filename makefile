sdkroot=c:\users\u8006988\garminSDK
projectroot=c:\users\u8006988\projects\WebRequest
build :
	$(sdkroot)\bin\monkeyc  -y $(sdkroot)\keys\developer_key.der -o $(projectroot)\WebRequest.prg -f $(projectroot)\monkey.jungle 

all: build
	$(sdkroot)\bin\connectiq
	$(sdkroot)\bin\monkeydo $(projectroot)\WebRequest.prg fr920xt

rerun:	
	$(sdkroot)\bin\monkeydo $(projectroot)\WebRequest.prg fr920xt
