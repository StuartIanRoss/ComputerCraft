fs.makeDir('/bin')
fs.makeDir('/etc')
fs.makeDir('/lib')
fs.makeDir('/opt')
fs.makeDir('/usr')

if not fs.exists('/lib/libfetch') then fs.copy('/disk/libfetch','/lib/libfetch') end
if not fs.exists('/bin/ppt') then fs.copy('/disk/ppt','/bin/ppt') end
shell.run('/bin/ppt', 'get ppt')
shell.run('ppt', 'get makeBootDisk')