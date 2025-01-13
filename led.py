import time
from pynq.overlays.base import BaseOverlay

# Load the overlay
base = BaseOverlay("base.bit")

# Define the LEDs
leds = [base.leds[i] for i in range(4)]

# Function to run the LED sequence continuously
def led_sequence_continuous():
    try:
        while True:
            # Turn LEDs on one by one
            for i in range(len(leds)):
                leds[i].on()
                time.sleep(0.5)  # Wait for 0.5 seconds between each LED

            # Turn LEDs off one by one
            for i in range(len(leds)):
                leds[i].off()
                time.sleep(0.5)  # Wait for 0.5 seconds between each LED

    except KeyboardInterrupt:
        # Clean up when the program is interrupted
        for i in range(len(leds)):
            leds[i].off()
        print("\nLED sequence stopped.")

# Run the LED sequence continuously
if __name__ == "__main__":
    led_sequence_continuous()
