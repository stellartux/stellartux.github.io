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
    this.color = `hsl(30, 50%, ${Math.random() * 33 + 15}%)`
    this.size = Math.random() * 36 + 12
    this.offset = -this.size / 2
    this.speed = {
      x: 0.5 - Math.random(),
      y: Math.random() + 0.25
    }
    this.angle = 0
    this.angularMomentum = (Math.random() - 0.5) * 0.07

    this.update = function () {
      this.position.x += this.speed.x
      this.position.x %= c.width + this.size * 2
      if (this.position.x < 0) this.position.x += c.width
      this.position.y += this.speed.y
      this.position.y %= c.height + this.size * 2
      this.angle += this.angularMomentum
      this.angle %= 2 * Math.PI
    }

    this.draw = function () {
      ctx.save()
      ctx.translate(this.position.x - this.size, this.position.y - this.size)
      ctx.fillStyle = this.color
      ctx.rotate(this.angle)
      ctx.fillRect(this.offset, this.offset, this.size, this.size)
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
