# MATLAB HashMap Implementation

## Motivation
MATLAB already has a built in class to handle Hash Map/Tables using `containers.Map()`.
However, support for differing data types is limited (optional arguments exist to support
differing data types. Some data types are not supported at all (structs, function handles,
etc).

This implementation gives you more of a modern implementation of hash maps, allowing mixing
of data types, functions/structs/classes as map keys, and concise language to improve
code readability.

### General
HashMap will auto rehash as new data gets added. Rehash determination is based on number of
entries in the map and current number of buckets allocated to the internal array.

A psudo seperate chaining takes place when hash collisions occur (psudo as in not using a
more traditional linked list as storage).

### Time and space complexity
Look up - Best/Average case O(1), worst case O(N) [when hash function produces key collisions]
Space - O(N) array increases linearly with number of dictionary entries

## Installation
Double click on the toolbox file (HashMap.mtlbx) or drag the file into the MATLAB command
window. This will install the class globally within MATLAB.

## Methods
- **get**(key) -> get value associated with key
- **set**(key,value) -> set new element in map by key and value
- **delete**(key) -> delete entry by key
- **has**(key) -> Returns true/false based on whether the map contains the key
- **keys**() -> returns all keys of map
- **values**() -> returns all values of map
- **size** - current size of the map (number of keys)

## Usage
### **Empty initialization**
`
map = HashMap();
map.size
`
> size = 0

### **initialization with data**
`
map = HashMap({'a','b','c'},{1,2,3});
map.size
`
> 3

### **Setting new data**
`
map = HashMap({'a','b','c'},{1,2,3});
map.size
`
> 3

`
map.set('d','4');
map.size
`
> 4

### **has key**
`
map.has('d')
`
> true

### **get value by key**
`
map.get('d')
`
> 4

### **delete data**
`
map.delete('a');
map.has('a')
map.size
`
> false, 3

### **collect keys**
`
map.keys()
`
> 'c'    'b'

### **collect values**
`
map.values()
`
> 3,    2