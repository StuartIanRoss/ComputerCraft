fs.makeDir('/bin')
fs.makeDir('/etc')
fs.makeDir('/lib')
fs.makeDir('/opt')
fs.makeDir('/usr')

shell.setDir('/disk')
shell.run('ppt', 'get ppt')
shell.setDir('/')
shell.run('ppt', 'get makeBootDisk')