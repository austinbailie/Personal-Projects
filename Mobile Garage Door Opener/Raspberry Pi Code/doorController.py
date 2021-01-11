import RPi.GPIO as GPIO
from time import sleep
import pyrebase

# Firebase database configuration
config = {

	"apiKey": "########",
	"authDomain": "#########",
	"databaseURL": "#########",
	"storageBucket": "###########"
}

# Initialize and connect to database
firebase = pyrebase.initialize_app(config)
database = firebase.database()

# Set up RaspberryPi pinout for servo and limit switch
GPIO.setmode(GPIO.BOARD)
GPIO.setup(03, GPIO.OUT)
GPIO.setup(40, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

pwm = GPIO.PWM(03, 50)
pwm.start(0)

# Converts a angle to a duty cycle number for the servo
def setAngle(angle):

	duty = angle / 18 + 2
	GPIO.output(03, True)
	pwm.ChangeDutyCycle(duty)
	sleep(0.5)
	GPIO.output(03, False)
	pwm.ChangeDutyCycle(0)
	
# Moves the servo to desired angles and ultimately opens the door
# Resets door command in database
def triggerDoor():
	
	setAngle(0)
	sleep(2)

	setAngle(35)
	sleep(3)

	setAngle(0)
	database.update({"DoorCommand":"None"})
	sleep(5)

# Gets door status on startup
doorStatus = database.child("DoorStatus").get().val()

# Loop checks for changes in database door status.
while True:
	
	# Looks for commands from database
	doorCommand = database.child("DoorCommand").get().val()
	
	# Updates door status in database (open/closed)
	if GPIO.input(40) == 1 and doorStatus == "Closed":
		doorStatus = "Open"
		database.update({"DoorStatus":"Open"})
		print("Door Open")
		
	elif GPIO.input(40) == 0 and doorStatus == "Open":
		doorStatus = "Closed"
		database.update({"DoorStatus":"Closed"})
		print("Door Closed")
		
	# Opens the door based on commands from the database
	if doorCommand == "Open" and doorStatus == "Closed":
		print("DOOR IS OPENING")
		triggerDoor()
		
	elif doorCommand == "Close" and doorStatus == "Open":		
		print("DOOR IS CLOSING")
		triggerDoor()


pwm.stop()
GPIO.cleanup()
