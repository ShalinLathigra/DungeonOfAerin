extends Node

export(int) var generic_key_count;
export(int) var used_key_count;
export(Array, int) var special_key_ids;
export(Array, int) var used_key_ids;

# Key usage
func add_key(var id: int = -1):
	if id >= 0 and not id in special_key_ids:
		special_key_ids.push_back(id);
	else:
		generic_key_count += 1;
	#print_key_summary();
	
func use_key(var id: int = -1):
	var ret = false;
	if id >= 0:
		# if id is one of the first indices in our array
		if id in special_key_ids and not id in used_key_ids:
			used_key_ids.append(id);
			ret = true;
	else:
		if used_key_count < generic_key_count:
			used_key_count += 1;
			ret = true;
	#print_key_summary();
	return ret;

func reset():
	generic_key_count=0
	used_key_count=0
	special_key_ids=[]
	used_key_ids=[]
		
func print_key_summary():
	print("PLAYERDATA:: key summary")
	print("Generic Keys: %d  -> Used: %d" % [generic_key_count, used_key_count])
	print("Has Keys: ")
	print(special_key_ids)
	print("Used Keys: ")
	print(used_key_ids)
