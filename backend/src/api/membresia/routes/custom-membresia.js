
module.exports = {
    routes: [
      {
        method: 'POST',
        path: '/membresias/stripe/webhook',
        handler: 'membresia.webHook',
      }
    ]
  }