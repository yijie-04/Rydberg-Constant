def read_file_to_list(filename):
    result = []
    with open(filename, 'r') as file:
        for line in file:
            numbers = line.split()
            if len(numbers) == 2:
                try:
                    result.append([float(numbers[0]), float(numbers[1])])
                except ValueError:
                    print(f"Warning: Couldn't convert {line.strip()} to floats.")
    return result

def write_list_to_file(data, filename):
    #writes the treated data to a new text file for plotting
    for sublist in data:
        if len(sublist) != 4:
            print(f"Warning: The sublist {sublist} does not have 4 elements. Skipping...")
            continue

        with open(filename, 'a') as file:
            file.write(f"{sublist[0]}\t{sublist[1]}\t{sublist[2]}\t{sublist[3]}\n")

def find_wavelengths(data_list, m, b, deltam, deltab):
    result = []
    for data in data_list:
        x1 = (data[0] - b)/m
        deltayb = ((data[1])**2 + (deltab)**2)**0.5
        deltax1 = x1 * ((deltayb/(data[0]-b))**2 + (deltam/m)**2)**0.5
        xf = (1/x1) + 286
        deltaxf = ((xf*(deltax1/x1))**2 + 4)**0.5
        result.append([xf, data[0], deltaxf, data[1]])
    return result

filename1 = "Unknown_gas.txt" #single slit data file
filename2 = "Unknown_gas_with_wavelengths.txt" #new text file name

data = read_file_to_list(filename1)

res = find_wavelengths(data, 1525.1559, 4.0718, 0.004707, 0.000024645)

print(res)

write_list_to_file(res, filename2)
