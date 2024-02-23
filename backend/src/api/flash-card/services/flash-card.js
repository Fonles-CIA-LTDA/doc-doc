'use strict';

/**
 * flash-card service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::flash-card.flash-card');
