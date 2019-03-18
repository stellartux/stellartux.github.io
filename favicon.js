const c = document.getElementById('canvas'), x = c.getContext('2d')
x.fillStyle = '#10101d'
x.fillRect(0, 0, c.width, c.height)
x.translate(c.width * 0.66, c.height * 0.25)
x.rotate(1)
x.fillStyle = `hsl(30, 50%, 33%)`
x.fillRect(0, 0, c.width * 0.45,c.width * 0.45)
