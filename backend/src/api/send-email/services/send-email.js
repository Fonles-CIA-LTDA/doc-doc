'use strict';

/**
 * send-email service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::send-email.send-email');
