#define board_rate 115200
#define pH_pin A1            //pH meter Analog output to Arduino Analog Input 0
#define pH_Offset -3.70            //deviation compensate

int pHArray[40];   //Store the average value of the sensor feedback
int pHArrayIndex=0;

void setup(void)
{
  Serial.begin(board_rate);
  Serial.println("pH meter experiment!");    //Test the serial monitor
}
void loop(void)
{
  static unsigned long samplingTime = millis();
  static unsigned long printTime = millis();
  static float pHValue,voltage;
  if(millis()-samplingTime > 20)
  {
    pHArray[pHArrayIndex++]=analogRead(pH_pin);
    if(pHArrayIndex==40)pHArrayIndex=0;
    voltage = avergearray(pHArray, 40)*5.0/1024;
    pHValue = 12.5*voltage+pH_Offset;
    samplingTime=millis();
  }
  if(millis() - printTime > 800)   //Every 800 milliseconds, print a numerical
  {
    Serial.print("Voltage:");
    Serial.print(voltage,2);
    Serial.print("    pH value: ");
    Serial.println(pHValue,2);
    printTime=millis();
  }
}
double avergearray(int* arr, int number){
  int i;
  int max,min;
  double avg;
  long amount=0;
  if(number<=0){
    Serial.println("Error number for the array to avraging!/n");
    return 0;
  }
  if(number<5){   //less than 5, calculated directly statistics
    for(i=0;i<number;i++){
      amount+=arr[i];
    }
    avg = amount/number;
    return avg;
  }
  else{
    if(arr[0]<arr[1]){
      min = arr[0];max=arr[1];
    }
    else{
      min=arr[1];max=arr[0];
    }
    for(i=2;i<number;i++){
      if(arr[i]<min){
        amount+=min;        //arr<min
        min=arr[i];
      }else {
        if(arr[i]>max){
          amount+=max;    //arr>max
          max=arr[i];
        }else{
          amount+=arr[i]; //min<=arr<=max
        }
      }//if
    }//for
    avg = (double)amount/(number-2);
  }//if
  return avg;
}
