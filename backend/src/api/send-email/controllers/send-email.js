'use strict';
const nodemailer = require("nodemailer");

let transporter = nodemailer.createTransport(
  {
    host: "smtp.hostinger.com",
    port: 465,
    secure: true,
    auth: {
      user: "admin@docdocenarm.com",
      pass: "Admin2024.",
    },
    logger: false,
    debug: false, // include SMTP traffic in the logs
  },
  {
    // sender info
    from: "No Reply <admin@docdocenarm.com>",
  }
);
/**
 * send-email controller
 */

const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::send-email.send-email',({ strapi }) => ({
  async sendEmailPassword(ctx) {
    const { code, email } = ctx.request.body;
    try {
      const info = await transporter.sendMail({
        from: '"No Reply" <admin@docdocenarm.com>', // sender address
        to: `${email}`, // list of receivers
        subject: "Restablecimiento de Contraseña", // Subject line
        text: "Restablecimiento de Contraseña", // plain text body
        html: `<!DOCTYPE html>
        <html lang="es">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Restablecimiento de Contraseña</title>
        <style>
          body { font-family: Arial, sans-serif; background-color: #f4f4f4; color: #333; }
          .container { max-width: 600px; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
          .header { color: #444; text-align: center; }
          .content { margin-top: 20px; }
          .footer { margin-top: 20px; font-size: 12px; text-align: center; color: #aaa; }
          .button { display: inline-block; padding: 10px 20px; background-color: #007bff; color: #ffffff; text-decoration: none; border-radius: 5px; }
        </style>
        </head>
        <body>
        <div class="container">
          <div class="header">
            <h2>Doc Doc</h2>
            <p>Restablecimiento de Contraseña</p>
          </div>
          <div class="content">
            <p>Hola,</p>
            <p>Has solicitado restablecer tu contraseña. Utiliza el siguiente código de verificación para continuar el proceso:</p>
            <p style="text-align: center; margin: 20px 0; font-size: 24px; font-weight: bold;">${code}</p>
            <p>Si no has solicitado un restablecimiento de contraseña, ignora este correo electrónico o ponte en contacto con nosotros.</p>
          </div>
          <div class="footer">
            <p>Gracias por utilizar Doc Doc.</p>
          </div>
        </div>
        </body>
        </html>
        `, // html body
      });
      return "ok";
    } catch (error) {
      return error;
    }

  }
}));
