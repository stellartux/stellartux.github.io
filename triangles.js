(() => {
  const c = document.getElementById('canvas')
  const resizeWindow = function () {
    c.width = window.innerWidth
    c.height = window.innerHeight
  }
  resizeWindow()
  window.addEventListener('resize', resizeWindow)
  const ctx = c.getContext('2d')
  const Box = function () {
    this.position = {
      x: Math.random() * c.width,
      y: Math.random() * c.height
    }
    this.color = `hsl(30, 50%, ${Math.random() * 25 + 15}%)`
    this.size = Math.random() * 36 + 12
    this.speed = 0.5 + Math.random() / 2
    this.angle = Math.random() * Math.PI * 2
    this.angularMomentum = Math.random() * 0.03

    this.update = function () {
      this.position.x += this.speed
      this.position.x %= c.width + this.size * 2
      this.position.y += this.speed
      this.position.y %= c.height + this.size * 2
      this.angle += this.angularMomentum
      this.angle %= 2 * Math.PI
    }

    this.draw = function () {
      ctx.fillStyle = this.color
      ctx.save()
      ctx.translate(this.position.x - this.size, this.position.y - this.size)
      ctx.rotate(this.angle)
      ctx.fillRect(0, 0, this.size, this.size)
      ctx.restore()
    }
  }
  const boxes = []
  for (let i = 0; i < 22; i++) {
    boxes.push(new Box())
  }

  return function innerDrawLoop (time = 0) {
    ctx.clearRect(0, 0, c.width, c.height)
    for (let b of boxes) {
      b.draw()
      b.update()
    }
    window.requestAnimationFrame(innerDrawLoop)
  }
})()()
