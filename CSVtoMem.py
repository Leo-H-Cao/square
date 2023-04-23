import csv
path = "C:/Users/lhc22/Desktop/square"

with open(path + "/start_screen_colors.csv", "r") as csvFile:
       with open(path + "/start_screen_colors.mem", "w") as memFile:
            for row in csv.reader(csvFile):
                memFile.write(" ".join(row) + "\n")

with open(path + "/start_screen.csv", "r") as csvFile:
    with open(path + "/start_screen.mem", "w") as memFile:
        for row in csv.reader(csvFile):
            memFile.write(" ".join(row) + "\n")
