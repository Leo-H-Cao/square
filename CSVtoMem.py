import csv
path = "C:/Users/lhc22/Desktop/square"

with open(path + "/title_colors.csv", "r") as csvFile:
       with open(path + "/title_colors.mem", "w") as memFile:
            for row in csv.reader(csvFile):
                memFile.write(" ".join(row) + "\n")

with open(path + "/title.csv", "r") as csvFile:
    with open(path + "/title.mem", "w") as memFile:
        for row in csv.reader(csvFile):
            memFile.write(" ".join(row) + "\n")
