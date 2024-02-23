'use strict';

/**
 * send-email router
 */

const { createCoreRouter } = require('@strapi/strapi').factories;

module.exports = createCoreRouter('api::send-email.send-email');
