-- Original version William Pond - 10/1/2013
-- Modified by Stuart Ross

args = { ... }

if #args < 2 then
  printf ("Usage: fetch <raw url> <output path>")
  return
end

url = args[1]
name = args[2]

src = http.get(url)

if src == nil then
  print("Failed to fetch" .. url)
  return
end

f = fs.open(name, "w")
f.write(src.readAll())
f.close()

src.close()

print "Done"