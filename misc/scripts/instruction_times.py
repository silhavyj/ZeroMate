import json

with open('instruction_times.json', 'r') as f:
    stats = json.load(f)
    
total_count = 0
weighted_time = 0
total_execution_time = 0
    
for instruction in stats['instructions']:
    total_count += instruction['count']
    weighted_time += instruction['time'] * instruction['count']
    instruction['weight'] = (instruction['time'] / 1e9) * instruction['count']
    total_execution_time += instruction['weight']
    instruction['time'] = round((1e9 / float(instruction['time'])) / 1e6, 2)
    
for instruction in stats['instructions']:
    instruction['count'] = round((instruction['count'] / total_count) * 100, 2)

stats['instructions'] = sorted(stats['instructions'], reverse=True, key=lambda i: i['weight'])

assert_count = 0.0

print(f'Total execution time {total_execution_time}')

for instruction in stats['instructions']:
    print(f"{instruction['count']}\t{instruction['time']}\t{round((instruction['weight'] / total_execution_time) * 100.0, 2)}\t{instruction['type']}")
    assert_count += instruction['count']
    
weighted_time /= total_count

print()

print(f'{float(weighted_time)} ns * x = 1s (1e9)')
print(f'x = 1e9 / {float(weighted_time)} = {1e9 / float(weighted_time)} inst/s = {(1e9 / float(weighted_time)) / 1e6} M_inst/s')
weighted_time = round((1e9 / float(weighted_time)) / 1e6, 2)

print()
print(f"Total instructions: {total_count}")
print(f"Weighted time: {weighted_time} Minst/s")

#print(f"percentage assertion check: {round(assert_count, 2)}")
#print()

#for instruction in stats['instructions']:
#    print(f"{instruction['type']}")
#print()

#for instruction in stats['instructions']:
#    print(f"{instruction['count']}")
#print()    

#for instruction in stats['instructions']:
#    print(f"{instruction['time']}")
#print()

#for instruction in stats['instructions']:
#    print(f"{instruction['weight']}")