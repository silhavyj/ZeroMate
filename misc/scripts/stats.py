import json

with open('stats.json', 'r') as f:
    stats = json.load(f)
    
total_count = 0
weighted_time = 0
    
for instruction in stats['instructions']:
    total_count += instruction['count']
    weighted_time += instruction['time'] * instruction['count']
    instruction['time'] = round((1e9 / float(instruction['time'])) / 1e6, 2)    
    
for instruction in stats['instructions']:
    instruction['count'] = round((instruction['count'] / total_count) * 100, 2)

stats['instructions'] = sorted(stats['instructions'], key=lambda i: i['time'])

assert_count = 0.0

for instruction in stats['instructions']:
    print(f"{instruction['count']}\t{instruction['time']}\t{instruction['type']}")
    assert_count += instruction['count']
    
weighted_time /= total_count
weighted_time = round((1e9 / float(weighted_time)) / 1e6, 2)

print()
print(f"Total instructions: {total_count}")
print(f"Weighted time: {weighted_time} Minst/s")

print(f"percentage assertion check: {assert_count}")