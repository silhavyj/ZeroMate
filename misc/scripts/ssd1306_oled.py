lines = []

with open('ssd1306_oled_i2c.txt', 'r') as file:
    for line in file.readlines():
        line = line.split('Received data: ')[1].split('\n')[0]
        lines.append(line)
    
line_str = ""
    
for line in lines:
    values = line.split()
    first = True
    #line_str = ""    
    for value in values:
        if first is True:
            first = False
            continue
        value_str = str(format(int(value), '#010b')).split('0b')[1]
        value_str = value_str.replace('0', '.')
        value_str = value_str.replace('1', '#')
        print(value_str)
        line_str += value_str
        #print(value_str)
    #print(line_str)
    #line_str = ""
        
    