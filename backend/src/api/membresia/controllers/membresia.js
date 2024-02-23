"use strict";
// @ts-ignore
const stripe = require("stripe")(
  "sk_test_51ObpmxGm16oBfwlsxumcQohXQpd7vJmzdGj3GA6tSAOBq9pJmg3q5kHYAXtxLxcUJ4DXKK757jNMqTayuMBDiKAt00UQRseQNY"
);

/**
 * membresia controller
 */

const { createCoreController } = require("@strapi/strapi").factories;

module.exports = createCoreController(
  "api::membresia.membresia",
  ({ strapi }) => ({
    async webHook(ctx) {
      let event;
      event = ctx.request.body.type;
      let idCustomer = ctx.request.body.data.object.customer;

      switch (event) {
        case "customer.subscription.created":
          const customer = await stripe.customers.retrieve(idCustomer);
          const usuarios = await strapi.entityService.findMany(
            "plugin::users-permissions.user",
            {
              filters: { email: customer.email },
            }
          );
          if (usuarios.length > 0) {
            const entriesCreate = await strapi.entityService.findMany(
              "api::membresia.membresia",
              {
                fields: ["id"],
                filters: {
                  users_permissions_user: {
                    id: usuarios[0].id,
                  },
                },
              }
            );

            if (entriesCreate.length === 0) {
              const entry = await strapi.entityService.create(
                "api::membresia.membresia",
                {
                  data: {
                    Id_Membresia: ctx.request.body.data.object.id,
                    Status: ctx.request.body.data.object.status,
                    type: "0",
                    Start_Date:
                      ctx.request.body.data.object.current_period_start.toString(),
                    End_Date:
                      ctx.request.body.data.object.current_period_end.toString(),
                    Mail: customer.email,
                    Id_Customer: idCustomer.toString(),
                  },
                }
              );
            } else {
              const updateStatus = await strapi.entityService.update(
                "api::membresia.membresia",
                // @ts-ignore
                entriesCreate[0].id,
                {
                  data: {
                    Status: ctx.request.body.data.object.status,
                    Id_Membresia: ctx.request.body.data.object.id,
                    Id_Customer: idCustomer.toString(),
                    type: "0",
                    Start_Date:
                      ctx.request.body.data.object.current_period_start.toString(),
                    End_Date:
                      ctx.request.body.data.object.current_period_end.toString(),
                  },
                }
              );
            }
          }

          break;
        case "customer.subscription.deleted":
          const customerD = await stripe.customers.retrieve(idCustomer);
          const usuariosD = await strapi.entityService.findMany(
            "plugin::users-permissions.user",
            {
              filters: { email: customerD.email },
            }
          );
          if (usuariosD.length > 0) {
            const entriesDelete = await strapi.entityService.findMany(
              "api::membresia.membresia",
              {
                filters: {
                  users_permissions_user: {
                    id: usuariosD[0].id,
                  },
                },
              }
            );
            let deleteInformation = ctx.request.body.data.object.status;
            const updateStatusDelete = await strapi.entityService.update(
              "api::membresia.membresia",
              entriesDelete[0].id,
              {
                data: {
                  Status: deleteInformation,
                  Start_Date: "",
                  End_Date: "",
                },
              }
            );
          }
          break;
        case "customer.subscription.updated":
          const customerSU = await stripe.customers.retrieve(idCustomer);
          const usuariosU = await strapi.entityService.findMany(
            "plugin::users-permissions.user",
            {
              filters: { email: customerSU.email },
            }
          );
          if (usuariosU.length > 0) {
            const entriesSU = await strapi.entityService.findMany(
              "api::membresia.membresia",
              {
                filters: {
                  users_permissions_user: {
                    id: usuariosU[0].id,
                  },
                },
              }
            );
            let sUInformation = ctx.request.body.data.object.status;
            const updateStatusSU = await strapi.entityService.update(
              "api::membresia.membresia",
              entriesSU[0].id,
              {
                data: {
                  Status: sUInformation,
                  Start_Date: "",
                  End_Date: "",
                },
              }
            );
          }

          break;
        case "invoice.paid":
          let idSubsPaid = ctx.request.body.data.object.subscription;
          let subscriptionPaid = await stripe.subscriptions.retrieve(
            idSubsPaid
          );
          const customerI = await stripe.customers.retrieve(idCustomer);
          const usuariosP = await strapi.entityService.findMany(
            "plugin::users-permissions.user",
            {
              filters: { email: customerI.email },
            }
          );
          if (usuariosP.length > 0) {
            const entries = await strapi.entityService.findMany(
              "api::membresia.membresia",
              {
                filters: {
                  users_permissions_user: {
                    id: usuariosP[0].id,
                  },
                },
              }
            );
            const updateStatus = await strapi.entityService.update(
              "api::membresia.membresia",
              entries[0].id,
              {
                data: {
                  Status: ctx.request.body.data.object.status,
                  Start_Date: subscriptionPaid.current_period_start.toString(),
                  End_Date: subscriptionPaid.current_period_end.toString(),
                },
              }
            );
          }

          break;
        case "checkout.session.completed":
          if (
            ctx.request.body.data.object.amount_total == "24900" ||
            ctx.request.body.data.object.amount_total == "49900"
          ) {
            if (ctx.request.body.data.object.amount_total == "24900") {
              console.log("3 meses");
            }
            if (ctx.request.body.data.object.amount_total == "49900") {
              console.log("6 meses");
            }
            const usariosFj = await strapi.entityService.findMany(
              "plugin::users-permissions.user",
              {
                filters: {
                  email: ctx.request.body.data.object.customer_details.email,
                },
              }
            );
            if (usariosFj.length > 0) {
              const fechaActual = new Date();

              // Convertir la fecha actual a formato Unix (segundos desde el epoch)
              const unixActual = Math.floor(fechaActual.getTime() / 1000);
              const fechaMasTresMeses = new Date(fechaActual);
              fechaMasTresMeses.setMonth(fechaActual.getMonth() + 3);

              // Convertir la fecha más 3 meses a formato Unix
              const unixMasTresMeses = Math.floor(
                fechaMasTresMeses.getTime() / 1000
              );

              const fechaMasSeisMeses = new Date(fechaActual);
              fechaMasSeisMeses.setMonth(fechaActual.getMonth() + 6);

              // Convertir la fecha más 3 meses a formato Unix
              const unixMasSeisMeses = Math.floor(
                fechaMasSeisMeses.getTime() / 1000
              );

              const entriesCreateFJ = await strapi.entityService.findMany(
                "api::membresia.membresia",
                {
                  fields: ["id"],
                  filters: {
                    users_permissions_user: {
                      id: usariosFj[0].id,
                    },
                  },
                }
              );

              if (entriesCreateFJ.length === 0) {
                await strapi.entityService.create("api::membresia.membresia", {
                  data: {
                    Id_Membresia: ctx.request.body.data.object.id,
                    Status: ctx.request.body.data.object.status,
                    type:
                      ctx.request.body.data.object.amount_total == "24900"
                        ? "1"
                        : "2",
                    Start_Date: unixActual.toString(),
                    End_Date:
                      ctx.request.body.data.object.amount_total == "24900"
                        ? unixMasTresMeses.toString()
                        : unixMasSeisMeses.toString(),
                    Id_Customer: "unico",
                    users_permissions_user: usariosFj[0].id,
                  },
                });
              } else {
                await strapi.entityService.update(
                  "api::membresia.membresia",
                  // @ts-ignore
                  entriesCreateFJ[0].id,
                  {
                    data: {
                      Status: ctx.request.body.data.object.status,
                      Id_Membresia: ctx.request.body.data.object.id,
                      type:
                        ctx.request.body.data.object.amount_total == "24900"
                          ? "1"
                          : "2",
                      Id_Customer: "unico",
                      Start_Date: unixActual.toString(),
                      End_Date:
                        ctx.request.body.data.object.amount_total == "24900"
                          ? unixMasTresMeses.toString()
                          : unixMasSeisMeses.toString(),
                    },
                  }
                );
              }
            }
          }

          break;
        case "invoice.payment_failed":
          const customerF = await stripe.customers.retrieve(idCustomer);

          const usuariosF = await strapi.entityService.findMany(
            "plugin::users-permissions.user",
            {
              filters: { email: customerF.email },
            }
          );
          if (usuariosF.length > 0) {
            const entriesFailed = await strapi.entityService.findMany(
              "api::membresia.membresia",
              {
                filters: {
                  users_permissions_user: {
                    id: usuariosP[0].id,
                  },
                },
              }
            );
            let failedInformation = ctx.request.body.data.object.status;
            const updateStatusFailed = await strapi.entityService.update(
              "api::membresia.membresia",
              entriesFailed[0].id,
              {
                data: {
                  Status: failedInformation,
                  Start_Date: "",
                  End_Date: "",
                },
              }
            );

            // Then define and call a function to handle the event payment_intent.succeeded
          }

          break;
        default:
          console.log(`Unhandled event type ${event}`);
      }
      ctx.send("");
      return {
        data: "ok",
      };
    },

    async deleteSubscription(ctx) {
      const { idSubs } = ctx.request.body;
      const deleted = await stripe.subscriptions.cancel(idSubs);
      ctx.send("");
      return {
        data: "ok",
      };
    },
    async updateSubscriptionMail(ctx) {
      const { idCustomer, mail } = ctx.request.body;
      const customer = await stripe.customers.update(idCustomer, {
        metadata: { email: mail },
        email: mail,
      });

      ctx.send("");
      return {
        data: "ok",
      };
    },
  })
);
