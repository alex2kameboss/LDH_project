# Define the filename
filename = "file_in8b.raw"

# Open the file in write mode
with open(filename, "w") as file:
    # Write 32 lines of binary numbers
    for i in range(32):
        # Format the number as an 8-bit binary string and write it to the file
        file.write(f"{i:08b}\n")

print(f"File '{filename}' has been created with 32 lines of binary numbers.")