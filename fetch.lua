-- Original version William Pond - 10/1/2013

args = { ... }

if #args < 2 then
	printf ("Usage: fetch <raw url> <name>")
	return
end

url = args[1]
name = args[2]

src = http.get(url)

if src == nil then
	print("Unable to fetch")
	return
end

if not fs.exists("/downloads") then
	fs.makeDir("/downloads")
end

f = fs.open("/downloads/" .. name, "w")
f.write(src.readAll())
f.close()

src.close()

print "Done"