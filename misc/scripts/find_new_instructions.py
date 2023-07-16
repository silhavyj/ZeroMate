import sys

def get_instructions(filename) -> set():
    lines = []
    instructions = set()
    
    with open(filename, 'r') as file:
        lines = file.readlines()
        
    start = False
        
    for line in lines:
        if start is False and line.startswith('Disassembly of section .text:'):
            start = True
        elif start is True and line.startswith('Disassembly'):
            break
            
        line = line.strip()
        parts = line.split()
        if len(line) == 0:
            continue
        if parts[0][len(parts[0]) - 1] == ':' and len(parts[0]) == 9:
            if len(parts) >= 3:
                #print(parts[2])
                instructions.add(parts[2])
                
    return instructions
    

def find_diff(inst1: set(), inst2: set()):
    for inst in inst1:
        if inst not in inst2:
            print(inst)


if __name__ == "__main__":
    inst1 = get_instructions(sys.argv[1])
    inst2 = get_instructions(sys.argv[2])
    
    print(f'found in {sys.argv[1]} but not in {sys.argv[2]}')
    find_diff(inst1, inst2)
    
    print(f'found in {sys.argv[2]} but not in {sys.argv[1]}')
    find_diff(inst2, inst1)
    
    