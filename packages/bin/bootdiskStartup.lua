-- Pew OS startup script
-- Originally by Stuart Ross, 12/01/2013
-- Modified by Harry Gordon, 01/12/2013

-- Artwork for start up
local art = 
  " _____               ____   _____  \n" ..
  "|  __ \\             / __ \\ / ____| \n" ..
  "| |__) |____      _| |  | | (___   \n" ..
  "|  ___/ _ \\ \\ /\\ / / |  | |\\___ \\  \n" ..
  "| |  |  __/\\ V  V /| |__| |____) | \n" ..
  "|_|   \\___| \\_/\\_/  \\____/|_____/  "

-- Create required folders
fs.makeDir('/bin')
fs.makeDir('/etc')
fs.makeDir('/lib')
fs.makeDir('/opt')
fs.makeDir('/usr')

-- Move libfetch, ppt and startup script
if not fs.exists('/lib/libfetch') then fs.copy('/disk/libfetch','/lib/libfetch') end
if not fs.exists('/bin/ppt') then fs.copy('/disk/ppt','/bin/ppt') end
if not fs.exists('/startup') then fs.copy('/disk/startup','/startup') end

-- Set up ppt (not sure how this works - HG)
shell.run('/bin/ppt', 'get ppt')

-- Get makeBootDisk
shell.run('ppt', 'get makeBootDisk')

-- Finish up with some art and clear
os.sleep(1)
print(art)
os.sleep(1)
shell.run("clear")