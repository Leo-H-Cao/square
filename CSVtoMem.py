import csv
path = "C:/Users/lhc22/Desktop/square"

with open(path + "/field_colors.csv", "r") as csvFile:
       with open(path + "/field_colors.mem", "w") as memFile:
            for row in csv.reader(csvFile):
                memFile.write(" ".join(row) + "\n")

with open(path + "/field.csv", "r") as csvFile:
    with open(path + "/field.mem", "w") as memFile:
        for row in csv.reader(csvFile):
            memFile.write(" ".join(row) + "\n")
