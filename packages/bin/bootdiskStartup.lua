fs.makeDir('/bin')
fs.makeDir('/etc')
fs.makeDir('/lib')
fs.makeDir('/opt')
fs.makeDir('/usr')

shell.run('ppt', 'get ppt')
shell.run('ppt', 'get makeBootDisk')