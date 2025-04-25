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
	rm *.prg* *.iq

package: 
	${sdkroot}/bin/monkeyc -e -a ${sdkroot}/bin/api.db -i ${sdkroot}/bin/api.debug.xml -o ./oura.iq -y ~/garmin/keys/developer_key.der -w -u ${sdkroot}/bin/devices.xml -p ${sdkroot}/bin/projectInfo.xml -f ./monkey.jungle

