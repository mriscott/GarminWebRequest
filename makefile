sdkroot=~/garmin/sdk/
projectroot=~/src/GarminWebRequest
build :
	$(sdkroot)/bin/monkeyc  -y ~/garmin/keys/developer_key.der -o $(projectroot)/oura.prg -f $(projectroot)/monkey.jungle 

all: build
	$(sdkroot)/bin/connectiq
	$(sdkroot)/bin/monkeydo $(projectroot)/oura.prg fr735xt

rerun:	
	$(sdkroot)/bin/monkeydo $(projectroot)/oura.prg fr735xt

clean:
	rm *.prg
