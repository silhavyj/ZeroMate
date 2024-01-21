import json

with open('instruction_times.json', 'r') as f:
    stats = json.load(f)
    
total_count = 0
weighted_time = 0
    
for instruction in stats['instructions']:
    total_count += instruction['count']
    weighted_time += instruction['time'] * instruction['count']
    instruction['weight'] = round((instruction['time'] / 1e9) * instruction['count'], 3)
    instruction['time'] = round((1e9 / float(instruction['time'])) / 1e6, 2)
    
for instruction in stats['instructions']:
    instruction['count'] = round((instruction['count'] / total_count) * 100, 2)

stats['instructions'] = sorted(stats['instructions'], reverse=True, key=lambda i: i['weight'])

assert_count = 0.0

for instruction in stats['instructions']:
    print(f"{instruction['count']}\t{instruction['time']}\t{instruction['weight']}\t{instruction['type']}")
    assert_count += instruction['count']
    
weighted_time /= total_count
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