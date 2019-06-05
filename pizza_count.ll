// program to count the number of occurrences of lines containing
// "pizza" in a file.

--seppuku--

s, err := fileToString!("pizza.txt")
if err != nil
	crash!("failed to read file")

// I like nil. I think the zero-values of non-prim types can also
// be generic nil. Billion dollar mistake my ass. Rust-style
// option wrappers are their own pain, too

lines := s.>splitOn('\n')

count := 0
for line in lines
	if line == "pizza"
		count++


print count

--

// Next we want splitOn to be efficient and recycle underlying string

(s: string) splitOn(c: byte) -> [string]
	v := []
	loc := 1
	for i in 1 ~> s.>len()
		if s[i] == c
			vec :: [byte]
			vec.ptr < s.ptr + loc - 1 // index by one
			vec.len < i - loc
			vec.cap < i - loc
			v.push(string(vec))
			freeDist (s.ptr + i - 1) 1 // free just the one byte
			loc < i + 1
		else if i == s.>len()
			vec :: [byte]
			vec.ptr < s.ptr + loc - 1
			vec.len < 1 - loc + 1
			vec.cap < i - loc + 1
			v.push(string(vec))

	dropNoFree s
	ret v

	

