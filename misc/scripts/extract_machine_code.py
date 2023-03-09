import sys

if __name__ == '__main__':
    lines = []
    
    with open(sys.argv[1], 'r') as file:
        lines = file.readlines()
    
    raw_bytes = ''
    new_line_counter = 0
    
    for line in lines:
        if 'Disassembly of section .ARM.attributes:' in line:
            break
        parts = line.split()
        if len(parts) > 0:
            if len(parts[1]) == 8:
                raw_bytes += '0x' + parts[1] + ', '
                if new_line_counter == 4:
                    raw_bytes += '\n'
                    new_line_counter = 0
                else:
                    new_line_counter += 1
                
    raw_bytes = raw_bytes[:-2]
    
    with open('raw_bytes.bin', 'w') as file:
        file.write(raw_bytes)
