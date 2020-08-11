## 사용한 라이브러리

 - #### ethercard
   이더넷 모듈 사용에 필요
   https://github.com/njh/EtherCard


- #### ArduinoJson
  POST 및 GET 요청시 데이터를 Json형태로 변형
  https://github.com/bblanchon/ArduinoJson (6.x ver 사용)
   

- #### OneWire
  수온센서 핀 설정에 필요
  https://github.com/PaulStoffregen/OneWire


- #### DallasTemperature
  수온센서 핀 설정에 따른 센서 값 측정
  https://github.com/milesburton/Arduino-Temperature-Control-Library


- #### ArduinoUniqueID
  아두이노 고유 기기값 번호
  https://github.com/ricaun/ArduinoUniqueID


- #### GravityTDS
  ec값 측정에 필요
  https://github.com/DFRobot/GravityTDS




##  센서 목록 및 참조 사이트

- ##### pH 센서

  범위: 0~14

  ##### 측정기

  - 포켓용 pH 측정기 pH Testr 30 사용법

    https://www.youtube.com/watch?v=WdvbWw2bxVg

  - pH 시범실험

    https://www.youtube.com/watch?v=GOLR-3qXE-M

  ##### pH 센서

  - pH meter로 커피물 pH측정하기 [아두이노 강좌]

    https://blog.naver.com/roboholic84/220550642030


- ##### 조도센서

  범위: 0~1023 (0~100으로 map할 예정)

  - CDS Sensor Module 조도센서모듈

    https://zelkun.tistory.com/entry/011-Arduino-아두이노-CDS-Sensor-Module-조도센서모듈


- ##### 수온센서

  범위: -55 ~ 120 도

  - 방수 온도센서(Waterproof DS18B20) 아두이노와 사용하기

    http://blog.naver.com/PostView.nhn?blogId=ubicomputing&logNo=220603948881

  문제: device 찾지 못한다고도 했음; 해결: 저항 추가 회로로 구성하여 해결

  문제: Mega보드로 변경 후 센서를 인식하지 못하는 문제; 해결: DallasTemperature라이브러리를 사용하여 해결
    
    https://forum.arduino.cc/index.php?topic=102729.0


- ##### 릴레이 모듈

  - 솔레노이드 밸브 x 릴레이 모듈

    https://kocoafab.cc/tutorial/view/345


- ##### TDS 센서: 양액관리

  https://wiki.dfrobot.com/Gravity__Analog_TDS_Sensor___Meter_For_Arduino_SKU__SEN0244


- ##### 수위센서

  - Liquid level sensor

    https://wiki.dfrobot.com/Liquid_Level_Sensor-FS-IR02_SKU__SEN0205


- ##### 온습도 센서(DHT11)

  - DHT11 온도 습도 센서 테스트

    http://www.hardcopyworld.com/ngine/aduino/index.php/archives/190


- ##### 아두이노 고유 번호

  - Arduino has a unique ID!

    https://www.thethingsnetwork.org/forum/t/arduino-has-a-unique-id/21415


- ##### 이더넷 모듈(ENC28J60)

  - 이더넷모듈(ENC28J60)의 사용 - 설정,웹서버,트위터,웹클라이언트

    https://deneb21.tistory.com/284

  - Ethercard GET 예제

    https://www.aelius.com/njh/ethercard/persistence_8ino-example.html#a16

  - Ethercard POST 예제

    https://stackoverflow.com/questions/17791876/sending-http-post-request-with-arduino-and-enc28j60-ethernet-lan-network-module


