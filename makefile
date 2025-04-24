sdkroot=~/garmin/sdk/
projectroot=~/src/GarminWebRequest
build :
	$(sdkroot)/bin/monkeyc  -y ~/garmin/keys/developer_key.der -o $(projectroot)/oura.prg -f $(projectroot)/monkey.jungle 

all: build
	$(sdkroot)/bin/connectiq
	sleep 5
	$(sdkroot)/bin/monkeydo $(projectroot)/oura.prg fenix6pro

rerun:	
	$(sdkroot)/bin/monkeydo $(projectroot)/oura.prg fenix6pro

clean:
	rm *.prg*
