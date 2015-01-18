/*
 * SerPins
 * 
 * Control the pins 0 to 7 via simple serial commands.
 * Commands must be terminated with \r\n.
 *
 * Commands:
 * 
 * P0 1 ... Set pin 0 high
 * P7 0 ... Set pin 7 low
 * RESET ... Set all pin to default state (high)
 *
 * Return values:
 *
 * OK ... Command executed
 * ERROR ... Syntax error
 */

#define BUFSIZE 10

// Initialize all pins to high
void init_pins() {
  for (unsigned char pin = 0; pin <= 7; pin++) {
    pinMode(pin, OUTPUT);
    digitalWrite(pin, HIGH);
  }
}

void setup() {
  // Initialize all pins to high
  init_pins();
  // Set up serial and wait for it to become ready
  Serial.begin(9600);
  while (!Serial) {}
  // Default 1000ms timeout introduces an excessive delay on parse errors
  Serial.setTimeout(100);
}

void loop() {
  
  char cmd[BUFSIZE];
  memset(cmd, 0, BUFSIZE);

  if (Serial.available() == 0)
    return;
  
  // Read up to (but not including) \n. The \n is thrown away.
  int n = Serial.readBytesUntil('\n', cmd, BUFSIZE - 1);
  
  // The shortest valid message is "P0 0\r" (5 bytes)
  if ( n < 5)
    goto err;
  
  // Timeout or invalid line ending
  if ( cmd[n-1] != '\r' )
    goto err;
  
  // Remove line ending to simplify strcmp
  cmd[n-1] = 0;
  
  // Parse actual command
  if ( cmd[0] == 'P' && cmd[2] == ' ' ) {
    // Testcases: "P3 1", "P7 0"
    
    unsigned char pin = cmd[1] - '0';
    unsigned char val = cmd[3] - '0'; 

    if ( pin < 0 || pin > 7 || ( val != 0 && val != 1) )
      goto err;
    
    digitalWrite(pin, val);
    goto ok;

  } else if ( strcmp(cmd, "RESET") == 0 ) {
    // Testcase: RESET
    init_pins();
    goto ok;
  } else
    goto err;
  
  err:
    Serial.println("ERROR");
    return;
  
  ok:
    Serial.println("OK");
    return;
}
