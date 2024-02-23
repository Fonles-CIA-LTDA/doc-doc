import type { Schema, Attribute } from '@strapi/strapi';

export interface AdminPermission extends Schema.CollectionType {
  collectionName: 'admin_permissions';
  info: {
    name: 'Permission';
    description: '';
    singularName: 'permission';
    pluralName: 'permissions';
    displayName: 'Permission';
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    action: Attribute.String &
      Attribute.Required &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }>;
    actionParameters: Attribute.JSON & Attribute.DefaultTo<{}>;
    subject: Attribute.String &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }>;
    properties: Attribute.JSON & Attribute.DefaultTo<{}>;
    conditions: Attribute.JSON & Attribute.DefaultTo<[]>;
    role: Attribute.Relation<'admin::permission', 'manyToOne', 'admin::role'>;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'admin::permission',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'admin::permission',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface AdminUser extends Schema.CollectionType {
  collectionName: 'admin_users';
  info: {
    name: 'User';
    description: '';
    singularName: 'user';
    pluralName: 'users';
    displayName: 'User';
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    firstname: Attribute.String &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }>;
    lastname: Attribute.String &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }>;
    username: Attribute.String;
    email: Attribute.Email &
      Attribute.Required &
      Attribute.Private &
      Attribute.Unique &
      Attribute.SetMinMaxLength<{
        minLength: 6;
      }>;
    password: Attribute.Password &
      Attribute.Private &
      Attribute.SetMinMaxLength<{
        minLength: 6;
      }>;
    resetPasswordToken: Attribute.String & Attribute.Private;
    registrationToken: Attribute.String & Attribute.Private;
    isActive: Attribute.Boolean &
      Attribute.Private &
      Attribute.DefaultTo<false>;
    roles: Attribute.Relation<'admin::user', 'manyToMany', 'admin::role'> &
      Attribute.Private;
    blocked: Attribute.Boolean & Attribute.Private & Attribute.DefaultTo<false>;
    preferedLanguage: Attribute.String;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<'admin::user', 'oneToOne', 'admin::user'> &
      Attribute.Private;
    updatedBy: Attribute.Relation<'admin::user', 'oneToOne', 'admin::user'> &
      Attribute.Private;
  };
}

export interface AdminRole extends Schema.CollectionType {
  collectionName: 'admin_roles';
  info: {
    name: 'Role';
    description: '';
    singularName: 'role';
    pluralName: 'roles';
    displayName: 'Role';
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    name: Attribute.String &
      Attribute.Required &
      Attribute.Unique &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }>;
    code: Attribute.String &
      Attribute.Required &
      Attribute.Unique &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }>;
    description: Attribute.String;
    users: Attribute.Relation<'admin::role', 'manyToMany', 'admin::user'>;
    permissions: Attribute.Relation<
      'admin::role',
      'oneToMany',
      'admin::permission'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<'admin::role', 'oneToOne', 'admin::user'> &
      Attribute.Private;
    updatedBy: Attribute.Relation<'admin::role', 'oneToOne', 'admin::user'> &
      Attribute.Private;
  };
}

export interface AdminApiToken extends Schema.CollectionType {
  collectionName: 'strapi_api_tokens';
  info: {
    name: 'Api Token';
    singularName: 'api-token';
    pluralName: 'api-tokens';
    displayName: 'Api Token';
    description: '';
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    name: Attribute.String &
      Attribute.Required &
      Attribute.Unique &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }>;
    description: Attribute.String &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }> &
      Attribute.DefaultTo<''>;
    type: Attribute.Enumeration<['read-only', 'full-access', 'custom']> &
      Attribute.Required &
      Attribute.DefaultTo<'read-only'>;
    accessKey: Attribute.String &
      Attribute.Required &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }>;
    lastUsedAt: Attribute.DateTime;
    permissions: Attribute.Relation<
      'admin::api-token',
      'oneToMany',
      'admin::api-token-permission'
    >;
    expiresAt: Attribute.DateTime;
    lifespan: Attribute.BigInteger;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'admin::api-token',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'admin::api-token',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface AdminApiTokenPermission extends Schema.CollectionType {
  collectionName: 'strapi_api_token_permissions';
  info: {
    name: 'API Token Permission';
    description: '';
    singularName: 'api-token-permission';
    pluralName: 'api-token-permissions';
    displayName: 'API Token Permission';
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    action: Attribute.String &
      Attribute.Required &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }>;
    token: Attribute.Relation<
      'admin::api-token-permission',
      'manyToOne',
      'admin::api-token'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'admin::api-token-permission',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'admin::api-token-permission',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface AdminTransferToken extends Schema.CollectionType {
  collectionName: 'strapi_transfer_tokens';
  info: {
    name: 'Transfer Token';
    singularName: 'transfer-token';
    pluralName: 'transfer-tokens';
    displayName: 'Transfer Token';
    description: '';
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    name: Attribute.String &
      Attribute.Required &
      Attribute.Unique &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }>;
    description: Attribute.String &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }> &
      Attribute.DefaultTo<''>;
    accessKey: Attribute.String &
      Attribute.Required &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }>;
    lastUsedAt: Attribute.DateTime;
    permissions: Attribute.Relation<
      'admin::transfer-token',
      'oneToMany',
      'admin::transfer-token-permission'
    >;
    expiresAt: Attribute.DateTime;
    lifespan: Attribute.BigInteger;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'admin::transfer-token',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'admin::transfer-token',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface AdminTransferTokenPermission extends Schema.CollectionType {
  collectionName: 'strapi_transfer_token_permissions';
  info: {
    name: 'Transfer Token Permission';
    description: '';
    singularName: 'transfer-token-permission';
    pluralName: 'transfer-token-permissions';
    displayName: 'Transfer Token Permission';
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    action: Attribute.String &
      Attribute.Required &
      Attribute.SetMinMaxLength<{
        minLength: 1;
      }>;
    token: Attribute.Relation<
      'admin::transfer-token-permission',
      'manyToOne',
      'admin::transfer-token'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'admin::transfer-token-permission',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'admin::transfer-token-permission',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface PluginUploadFile extends Schema.CollectionType {
  collectionName: 'files';
  info: {
    singularName: 'file';
    pluralName: 'files';
    displayName: 'File';
    description: '';
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    name: Attribute.String & Attribute.Required;
    alternativeText: Attribute.String;
    caption: Attribute.String;
    width: Attribute.Integer;
    height: Attribute.Integer;
    formats: Attribute.JSON;
    hash: Attribute.String & Attribute.Required;
    ext: Attribute.String;
    mime: Attribute.String & Attribute.Required;
    size: Attribute.Decimal & Attribute.Required;
    url: Attribute.String & Attribute.Required;
    previewUrl: Attribute.String;
    provider: Attribute.String & Attribute.Required;
    provider_metadata: Attribute.JSON;
    related: Attribute.Relation<'plugin::upload.file', 'morphToMany'>;
    folder: Attribute.Relation<
      'plugin::upload.file',
      'manyToOne',
      'plugin::upload.folder'
    > &
      Attribute.Private;
    folderPath: Attribute.String &
      Attribute.Required &
      Attribute.Private &
      Attribute.SetMinMax<{
        min: 1;
      }>;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'plugin::upload.file',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'plugin::upload.file',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface PluginUploadFolder extends Schema.CollectionType {
  collectionName: 'upload_folders';
  info: {
    singularName: 'folder';
    pluralName: 'folders';
    displayName: 'Folder';
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    name: Attribute.String &
      Attribute.Required &
      Attribute.SetMinMax<{
        min: 1;
      }>;
    pathId: Attribute.Integer & Attribute.Required & Attribute.Unique;
    parent: Attribute.Relation<
      'plugin::upload.folder',
      'manyToOne',
      'plugin::upload.folder'
    >;
    children: Attribute.Relation<
      'plugin::upload.folder',
      'oneToMany',
      'plugin::upload.folder'
    >;
    files: Attribute.Relation<
      'plugin::upload.folder',
      'oneToMany',
      'plugin::upload.file'
    >;
    path: Attribute.String &
      Attribute.Required &
      Attribute.SetMinMax<{
        min: 1;
      }>;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'plugin::upload.folder',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'plugin::upload.folder',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface PluginContentReleasesRelease extends Schema.CollectionType {
  collectionName: 'strapi_releases';
  info: {
    singularName: 'release';
    pluralName: 'releases';
    displayName: 'Release';
  };
  options: {
    draftAndPublish: false;
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    name: Attribute.String & Attribute.Required;
    releasedAt: Attribute.DateTime;
    actions: Attribute.Relation<
      'plugin::content-releases.release',
      'oneToMany',
      'plugin::content-releases.release-action'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'plugin::content-releases.release',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'plugin::content-releases.release',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface PluginContentReleasesReleaseAction
  extends Schema.CollectionType {
  collectionName: 'strapi_release_actions';
  info: {
    singularName: 'release-action';
    pluralName: 'release-actions';
    displayName: 'Release Action';
  };
  options: {
    draftAndPublish: false;
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    type: Attribute.Enumeration<['publish', 'unpublish']> & Attribute.Required;
    entry: Attribute.Relation<
      'plugin::content-releases.release-action',
      'morphToOne'
    >;
    contentType: Attribute.String & Attribute.Required;
    release: Attribute.Relation<
      'plugin::content-releases.release-action',
      'manyToOne',
      'plugin::content-releases.release'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'plugin::content-releases.release-action',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'plugin::content-releases.release-action',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface PluginI18NLocale extends Schema.CollectionType {
  collectionName: 'i18n_locale';
  info: {
    singularName: 'locale';
    pluralName: 'locales';
    collectionName: 'locales';
    displayName: 'Locale';
    description: '';
  };
  options: {
    draftAndPublish: false;
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    name: Attribute.String &
      Attribute.SetMinMax<{
        min: 1;
        max: 50;
      }>;
    code: Attribute.String & Attribute.Unique;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'plugin::i18n.locale',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'plugin::i18n.locale',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface PluginUsersPermissionsPermission
  extends Schema.CollectionType {
  collectionName: 'up_permissions';
  info: {
    name: 'permission';
    description: '';
    singularName: 'permission';
    pluralName: 'permissions';
    displayName: 'Permission';
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    action: Attribute.String & Attribute.Required;
    role: Attribute.Relation<
      'plugin::users-permissions.permission',
      'manyToOne',
      'plugin::users-permissions.role'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'plugin::users-permissions.permission',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'plugin::users-permissions.permission',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface PluginUsersPermissionsRole extends Schema.CollectionType {
  collectionName: 'up_roles';
  info: {
    name: 'role';
    description: '';
    singularName: 'role';
    pluralName: 'roles';
    displayName: 'Role';
  };
  pluginOptions: {
    'content-manager': {
      visible: false;
    };
    'content-type-builder': {
      visible: false;
    };
  };
  attributes: {
    name: Attribute.String &
      Attribute.Required &
      Attribute.SetMinMaxLength<{
        minLength: 3;
      }>;
    description: Attribute.String;
    type: Attribute.String & Attribute.Unique;
    permissions: Attribute.Relation<
      'plugin::users-permissions.role',
      'oneToMany',
      'plugin::users-permissions.permission'
    >;
    users: Attribute.Relation<
      'plugin::users-permissions.role',
      'oneToMany',
      'plugin::users-permissions.user'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'plugin::users-permissions.role',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'plugin::users-permissions.role',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface PluginUsersPermissionsUser extends Schema.CollectionType {
  collectionName: 'up_users';
  info: {
    name: 'user';
    description: '';
    singularName: 'user';
    pluralName: 'users';
    displayName: 'User';
  };
  options: {
    draftAndPublish: false;
  };
  attributes: {
    username: Attribute.String &
      Attribute.Required &
      Attribute.Unique &
      Attribute.SetMinMaxLength<{
        minLength: 3;
      }>;
    email: Attribute.Email &
      Attribute.Required &
      Attribute.SetMinMaxLength<{
        minLength: 6;
      }>;
    provider: Attribute.String;
    password: Attribute.Password &
      Attribute.Private &
      Attribute.SetMinMaxLength<{
        minLength: 6;
      }>;
    resetPasswordToken: Attribute.String & Attribute.Private;
    confirmationToken: Attribute.String & Attribute.Private;
    confirmed: Attribute.Boolean & Attribute.DefaultTo<false>;
    blocked: Attribute.Boolean & Attribute.DefaultTo<false>;
    role: Attribute.Relation<
      'plugin::users-permissions.user',
      'manyToOne',
      'plugin::users-permissions.role'
    >;
    name: Attribute.String;
    state: Attribute.String;
    university: Attribute.String;
    examenes: Attribute.Relation<
      'plugin::users-permissions.user',
      'oneToMany',
      'api::examen.examen'
    >;
    membresia: Attribute.Relation<
      'plugin::users-permissions.user',
      'oneToOne',
      'api::membresia.membresia'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'plugin::users-permissions.user',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'plugin::users-permissions.user',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiEscalaEscala extends Schema.CollectionType {
  collectionName: 'escalas';
  info: {
    singularName: 'escala';
    pluralName: 'escalas';
    displayName: 'Escalas';
  };
  options: {
    draftAndPublish: true;
  };
  attributes: {
    Titulo: Attribute.String;
    Descripcion: Attribute.Text;
    Imagen: Attribute.Media;
    especialidades_escala: Attribute.Relation<
      'api::escala.escala',
      'manyToOne',
      'api::especialidades-escala.especialidades-escala'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    publishedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::escala.escala',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::escala.escala',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiEspecialidadEspecialidad extends Schema.CollectionType {
  collectionName: 'especialidades';
  info: {
    singularName: 'especialidad';
    pluralName: 'especialidades';
    displayName: 'Especialidades';
    description: '';
  };
  options: {
    draftAndPublish: false;
  };
  attributes: {
    Titulo: Attribute.String;
    sub_especialidades: Attribute.Relation<
      'api::especialidad.especialidad',
      'oneToMany',
      'api::sub-especialidad.sub-especialidad'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::especialidad.especialidad',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::especialidad.especialidad',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiEspecialidadesEscalaEspecialidadesEscala
  extends Schema.CollectionType {
  collectionName: 'especialidades_escalas';
  info: {
    singularName: 'especialidades-escala';
    pluralName: 'especialidades-escalas';
    displayName: 'Especialidades_Escalas';
  };
  options: {
    draftAndPublish: true;
  };
  attributes: {
    Titulo: Attribute.String;
    escalas: Attribute.Relation<
      'api::especialidades-escala.especialidades-escala',
      'oneToMany',
      'api::escala.escala'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    publishedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::especialidades-escala.especialidades-escala',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::especialidades-escala.especialidades-escala',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiEspecialidadesFlashCardEspecialidadesFlashCard
  extends Schema.CollectionType {
  collectionName: 'especialidades_flash_cards';
  info: {
    singularName: 'especialidades-flash-card';
    pluralName: 'especialidades-flash-cards';
    displayName: 'Especialidades_FlashCards';
  };
  options: {
    draftAndPublish: true;
  };
  attributes: {
    Titulo: Attribute.String;
    flash_cards: Attribute.Relation<
      'api::especialidades-flash-card.especialidades-flash-card',
      'oneToMany',
      'api::flash-card.flash-card'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    publishedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::especialidades-flash-card.especialidades-flash-card',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::especialidades-flash-card.especialidades-flash-card',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiEspecialidadesVisualEspecialidadesVisual
  extends Schema.CollectionType {
  collectionName: 'especialidades_visuales';
  info: {
    singularName: 'especialidades-visual';
    pluralName: 'especialidades-visuales';
    displayName: 'Especialidades_Visuales';
    description: '';
  };
  options: {
    draftAndPublish: false;
  };
  attributes: {
    Titulo: Attribute.String;
    sub_espe_visuals: Attribute.Relation<
      'api::especialidades-visual.especialidades-visual',
      'oneToMany',
      'api::sub-espe-visual.sub-espe-visual'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::especialidades-visual.especialidades-visual',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::especialidades-visual.especialidades-visual',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiExamenExamen extends Schema.CollectionType {
  collectionName: 'examenes';
  info: {
    singularName: 'examen';
    pluralName: 'examenes';
    displayName: 'Examenes';
    description: '';
  };
  options: {
    draftAndPublish: false;
  };
  attributes: {
    Fecha: Attribute.String;
    preguntas_examen: Attribute.Relation<
      'api::examen.examen',
      'oneToMany',
      'api::pregunta-examen.pregunta-examen'
    >;
    users_permissions_user: Attribute.Relation<
      'api::examen.examen',
      'manyToOne',
      'plugin::users-permissions.user'
    >;
    Titulo: Attribute.String;
    Nota: Attribute.Decimal & Attribute.DefaultTo<0>;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::examen.examen',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::examen.examen',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiFlashCardFlashCard extends Schema.CollectionType {
  collectionName: 'flash_cards';
  info: {
    singularName: 'flash-card';
    pluralName: 'flash-cards';
    displayName: 'FlashCards';
    description: '';
  };
  options: {
    draftAndPublish: true;
  };
  attributes: {
    Titulo: Attribute.String;
    Imagen: Attribute.Media;
    preguntas: Attribute.Relation<
      'api::flash-card.flash-card',
      'oneToMany',
      'api::pregunta.pregunta'
    >;
    especialidades_flash_card: Attribute.Relation<
      'api::flash-card.flash-card',
      'manyToOne',
      'api::especialidades-flash-card.especialidades-flash-card'
    >;
    preguntas_visuals: Attribute.Relation<
      'api::flash-card.flash-card',
      'oneToMany',
      'api::preguntas-visual.preguntas-visual'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    publishedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::flash-card.flash-card',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::flash-card.flash-card',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiMaterialEstudioMaterialEstudio
  extends Schema.CollectionType {
  collectionName: 'material_estudios';
  info: {
    singularName: 'material-estudio';
    pluralName: 'material-estudios';
    displayName: 'Material_Estudio';
    description: '';
  };
  options: {
    draftAndPublish: false;
  };
  attributes: {
    Imagen: Attribute.Media;
    Link: Attribute.Text;
    Titulo: Attribute.String;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::material-estudio.material-estudio',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::material-estudio.material-estudio',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiMembresiaMembresia extends Schema.CollectionType {
  collectionName: 'membresias';
  info: {
    singularName: 'membresia';
    pluralName: 'membresias';
    displayName: 'Membresias';
    description: '';
  };
  options: {
    draftAndPublish: false;
  };
  attributes: {
    Id_Membresia: Attribute.Text;
    Status: Attribute.Text;
    Start_Date: Attribute.String;
    Id_Customer: Attribute.Text;
    End_Date: Attribute.Text;
    users_permissions_user: Attribute.Relation<
      'api::membresia.membresia',
      'oneToOne',
      'plugin::users-permissions.user'
    >;
    type: Attribute.String;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::membresia.membresia',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::membresia.membresia',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiNoticiaNoticia extends Schema.CollectionType {
  collectionName: 'noticias';
  info: {
    singularName: 'noticia';
    pluralName: 'noticias';
    displayName: 'Noticias';
    description: '';
  };
  options: {
    draftAndPublish: false;
  };
  attributes: {
    Noticia: Attribute.RichText;
    Fecha: Attribute.Date;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::noticia.noticia',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::noticia.noticia',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiPreguntaPregunta extends Schema.CollectionType {
  collectionName: 'preguntas';
  info: {
    singularName: 'pregunta';
    pluralName: 'preguntas';
    displayName: 'Preguntas_Especialidad';
    description: '';
  };
  options: {
    draftAndPublish: true;
  };
  attributes: {
    sub_especialidade: Attribute.Relation<
      'api::pregunta.pregunta',
      'manyToOne',
      'api::sub-especialidad.sub-especialidad'
    >;
    Feedback: Attribute.Text;
    Contenido: Attribute.Text;
    Imagen: Attribute.Media;
    Respuestas: Attribute.Text;
    Respuesta_Correcta: Attribute.Integer;
    flash_card: Attribute.Relation<
      'api::pregunta.pregunta',
      'manyToOne',
      'api::flash-card.flash-card'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    publishedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::pregunta.pregunta',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::pregunta.pregunta',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiPreguntaExamenPreguntaExamen extends Schema.CollectionType {
  collectionName: 'preguntas_examen';
  info: {
    singularName: 'pregunta-examen';
    pluralName: 'preguntas-examen';
    displayName: 'Preguntas_Examen';
    description: '';
  };
  options: {
    draftAndPublish: false;
  };
  attributes: {
    Respuesta: Attribute.Text;
    correcto: Attribute.Boolean & Attribute.DefaultTo<false>;
    examene: Attribute.Relation<
      'api::pregunta-examen.pregunta-examen',
      'manyToOne',
      'api::examen.examen'
    >;
    pregunta: Attribute.JSON;
    completado: Attribute.Boolean & Attribute.DefaultTo<false>;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::pregunta-examen.pregunta-examen',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::pregunta-examen.pregunta-examen',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiPreguntasVisualPreguntasVisual
  extends Schema.CollectionType {
  collectionName: 'preguntas_visuals';
  info: {
    singularName: 'preguntas-visual';
    pluralName: 'preguntas-visuals';
    displayName: 'Preguntas_Visual';
  };
  options: {
    draftAndPublish: true;
  };
  attributes: {
    sub_espe_visual: Attribute.Relation<
      'api::preguntas-visual.preguntas-visual',
      'manyToOne',
      'api::sub-espe-visual.sub-espe-visual'
    >;
    Feedback: Attribute.Text;
    Contenido: Attribute.Text;
    Imagen: Attribute.Media;
    Respuestas: Attribute.Text;
    Respuesta_Correcta: Attribute.Integer;
    flash_card: Attribute.Relation<
      'api::preguntas-visual.preguntas-visual',
      'manyToOne',
      'api::flash-card.flash-card'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    publishedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::preguntas-visual.preguntas-visual',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::preguntas-visual.preguntas-visual',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiSendEmailSendEmail extends Schema.CollectionType {
  collectionName: 'send_emails';
  info: {
    singularName: 'send-email';
    pluralName: 'send-emails';
    displayName: 'send_emails';
  };
  options: {
    draftAndPublish: true;
  };
  attributes: {
    Titulo: Attribute.String;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    publishedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::send-email.send-email',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::send-email.send-email',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiSubEspeVisualSubEspeVisual extends Schema.CollectionType {
  collectionName: 'sub_espe_visuals';
  info: {
    singularName: 'sub-espe-visual';
    pluralName: 'sub-espe-visuals';
    displayName: 'Sub_Espe_Visual';
  };
  options: {
    draftAndPublish: true;
  };
  attributes: {
    Titulo: Attribute.String;
    especialidades_visuale: Attribute.Relation<
      'api::sub-espe-visual.sub-espe-visual',
      'manyToOne',
      'api::especialidades-visual.especialidades-visual'
    >;
    preguntas_visuals: Attribute.Relation<
      'api::sub-espe-visual.sub-espe-visual',
      'oneToMany',
      'api::preguntas-visual.preguntas-visual'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    publishedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::sub-espe-visual.sub-espe-visual',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::sub-espe-visual.sub-espe-visual',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

export interface ApiSubEspecialidadSubEspecialidad
  extends Schema.CollectionType {
  collectionName: 'sub_especialidades';
  info: {
    singularName: 'sub-especialidad';
    pluralName: 'sub-especialidades';
    displayName: 'Sub_Especialidades';
  };
  options: {
    draftAndPublish: true;
  };
  attributes: {
    Titulo: Attribute.String;
    especialidade: Attribute.Relation<
      'api::sub-especialidad.sub-especialidad',
      'manyToOne',
      'api::especialidad.especialidad'
    >;
    preguntas_especialidads: Attribute.Relation<
      'api::sub-especialidad.sub-especialidad',
      'oneToMany',
      'api::pregunta.pregunta'
    >;
    createdAt: Attribute.DateTime;
    updatedAt: Attribute.DateTime;
    publishedAt: Attribute.DateTime;
    createdBy: Attribute.Relation<
      'api::sub-especialidad.sub-especialidad',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
    updatedBy: Attribute.Relation<
      'api::sub-especialidad.sub-especialidad',
      'oneToOne',
      'admin::user'
    > &
      Attribute.Private;
  };
}

declare module '@strapi/types' {
  export module Shared {
    export interface ContentTypes {
      'admin::permission': AdminPermission;
      'admin::user': AdminUser;
      'admin::role': AdminRole;
      'admin::api-token': AdminApiToken;
      'admin::api-token-permission': AdminApiTokenPermission;
      'admin::transfer-token': AdminTransferToken;
      'admin::transfer-token-permission': AdminTransferTokenPermission;
      'plugin::upload.file': PluginUploadFile;
      'plugin::upload.folder': PluginUploadFolder;
      'plugin::content-releases.release': PluginContentReleasesRelease;
      'plugin::content-releases.release-action': PluginContentReleasesReleaseAction;
      'plugin::i18n.locale': PluginI18NLocale;
      'plugin::users-permissions.permission': PluginUsersPermissionsPermission;
      'plugin::users-permissions.role': PluginUsersPermissionsRole;
      'plugin::users-permissions.user': PluginUsersPermissionsUser;
      'api::escala.escala': ApiEscalaEscala;
      'api::especialidad.especialidad': ApiEspecialidadEspecialidad;
      'api::especialidades-escala.especialidades-escala': ApiEspecialidadesEscalaEspecialidadesEscala;
      'api::especialidades-flash-card.especialidades-flash-card': ApiEspecialidadesFlashCardEspecialidadesFlashCard;
      'api::especialidades-visual.especialidades-visual': ApiEspecialidadesVisualEspecialidadesVisual;
      'api::examen.examen': ApiExamenExamen;
      'api::flash-card.flash-card': ApiFlashCardFlashCard;
      'api::material-estudio.material-estudio': ApiMaterialEstudioMaterialEstudio;
      'api::membresia.membresia': ApiMembresiaMembresia;
      'api::noticia.noticia': ApiNoticiaNoticia;
      'api::pregunta.pregunta': ApiPreguntaPregunta;
      'api::pregunta-examen.pregunta-examen': ApiPreguntaExamenPreguntaExamen;
      'api::preguntas-visual.preguntas-visual': ApiPreguntasVisualPreguntasVisual;
      'api::send-email.send-email': ApiSendEmailSendEmail;
      'api::sub-espe-visual.sub-espe-visual': ApiSubEspeVisualSubEspeVisual;
      'api::sub-especialidad.sub-especialidad': ApiSubEspecialidadSubEspecialidad;
    }
  }
}
