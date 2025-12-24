import sys
import os

print(f"Python executable: {sys.executable}")
print(f"Working directory: {os.getcwd()}")

# List the contents of the working directory
print("Directory contents:")
for item in os.listdir(os.getcwd()):
    print(f"  {item}")


import apache_beam as beam

def test_apache_beam():
    # Create a simple pipeline that reads a collection, processes it, and prints the result
    with beam.Pipeline() as pipeline:
        result = (
            pipeline
            | 'Create data' >> beam.Create(['Hello', 'Apache', 'Beam'])
            | 'Format data' >> beam.Map(lambda word: f"Processed: {word}")
            | 'Print result' >> beam.Map(print)
        )

if __name__ == "__main__":
    try:
        test_apache_beam()
    except Exception as e:
        print(f"Error: {e}")
