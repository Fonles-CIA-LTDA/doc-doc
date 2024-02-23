"use strict";
const moment = require("moment");
/**
 * examen controller
 */

const { createCoreController } = require("@strapi/strapi").factories;

// @ts-ignore
module.exports = createCoreController("api::examen.examen", ({ strapi }) => ({
  async generateQualifyExamByUser(ctx) {
    const { idUser } = ctx.request.body;
    const entries = await strapi.entityService.findMany("api::examen.examen", {
      filters: { users_permissions_user: { id: idUser } },
    });
    const sumaNotas = entries.reduce(
      (acumulador, nota) => acumulador + nota.Nota,
      0
    );

    // Calcular el promedio
    const promedio = sumaNotas / entries.length;

    return {
      data: promedio.toFixed(2),
    };
  },
  async generateQualifyExamTop(ctx) {
    let listOfUsers = [];
    const usuarios = await strapi.entityService.findMany(
      "plugin::users-permissions.user",
      {
        populate: {
          examenes: true,
        },
      }
    );
    for (let index = 0; index < usuarios.length; index++) {
      const element = usuarios[index];
      const sumaNotas = element.examenes.reduce(
        (acumulador, nota) => acumulador + nota.Nota,
        0
      );
      const promedio = sumaNotas / element.examenes.length;
      listOfUsers.push({
        id: element.id,
        name: element.name,
        university: element.university,
        state: element.state,
        promedio: promedio,
      });
    }
    listOfUsers.sort((a, b) => b.promedio - a.promedio);

    // Si deseas limitar la lista a un máximo de 10 elementos
    listOfUsers = listOfUsers.slice(0,  Math.min(10, listOfUsers.length));

    // // Calcular el promedio

    return {
      data: listOfUsers,
    };
  },
  shuffle(array) {
    // Algoritmo de Fisher-Yates para mezclar el array
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]];
    }
  },
  async generateCompleteExamen(ctx) {
    const { idUser, title } = ctx.request.body;
    const fechaActual = moment();
    fechaActual.locale("es");
    const fechaFormateada = fechaActual.format("LL"); // 'LL' representa el formato de fecha en español

    var normalQuestionsList = [];
    var visualQuestionsList = [];
    var totalQuestions = [];
    let idsListExamQuestions = [];
    const normalQuestions = await strapi.entityService.findMany(
      "api::pregunta.pregunta",
      {
        populate: { sub_especialidade: true, flash_card: true, Imagen: true },
      }
    );
    const visualQuestions = await strapi.entityService.findMany(
      "api::preguntas-visual.preguntas-visual",
      {
        populate: { sub_espe_visual: true, flash_card: true, Imagen: true },
      }
    );
    this.shuffle(normalQuestions);

    // Desordenar las preguntas visuales
    this.shuffle(visualQuestions);
    totalQuestions = [
      {
        identificator: "especialidad",
        elementos: [...normalQuestions],
      },
      {
        identificator: "visual",
        elementos: [...visualQuestions],
      },
    ];
    for (let index = 0; index < totalQuestions.length; index++) {
      const elementoInternoPrincipal = totalQuestions[index];
      for (
        let indexIntero = 0;
        indexIntero < elementoInternoPrincipal.elementos.length;
        indexIntero++
      ) {
        const element = elementoInternoPrincipal.elementos[indexIntero];
        const entry = await strapi.entityService.create(
          "api::pregunta-examen.pregunta-examen",
          {
            data: {
              pregunta: JSON.stringify({
                identificator: elementoInternoPrincipal.identificator,
                elemento: element,
              }),
            },
          }
        );
        idsListExamQuestions.push(entry.id);
      }
    }
    const createExam = await strapi.entityService.create("api::examen.examen", {
      data: {
        preguntas_examen: idsListExamQuestions,
        users_permissions_user: idUser,
        Fecha: fechaFormateada,
        Titulo: title,
      },
    });

    return {
      data: createExam.id,
    };
  },

  async qualifyExam(ctx) {
    const { examInformation } = ctx.request.body;
    let totalPreguntasCorrectas = 0;
    let totalPreguntas =
      examInformation.attributes.preguntas_examen.data.length;
    for (
      let index = 0;
      index < examInformation.attributes.preguntas_examen.data.length;
      index++
    ) {
      const element = examInformation.attributes.preguntas_examen.data[index];
      let userAnswer = element.attributes.Respuesta;
      let correctQuestionAnswerJson = element.attributes.pregunta;
      let correctQuestionAnswerJsonDecode = JSON.parse(
        correctQuestionAnswerJson
      );
      if (userAnswer != null) {
        if (
          parseInt(userAnswer.toString()) + 1 ==
          correctQuestionAnswerJsonDecode.elemento.Respuesta_Correcta
        ) {
          totalPreguntasCorrectas++;
          element.attributes.Respuesta = parseInt(userAnswer.toString()) + 1;
          element.attributes.correcto = true;
          element.attributes.completado = true;
        } else {
          element.attributes.Respuesta = parseInt(userAnswer.toString()) + 1;
          element.attributes.correcto = false;
          element.attributes.completado = true;
        }
      } else {
        element.attributes.Respuesta = " ";
        element.attributes.correcto = false;
        element.attributes.completado = false;
      }
    }

    for (
      let index = 0;
      index < examInformation.attributes.preguntas_examen.data.length;
      index++
    ) {
      const element = examInformation.attributes.preguntas_examen.data[index];

      await strapi.entityService.update(
        "api::pregunta-examen.pregunta-examen",
        element.id,
        {
          data: {
            Respuesta: element.attributes.Respuesta.toString(),
            correcto: element.attributes.correcto,
            completado: element.attributes.completado,
          },
        }
      );
    }

    const porcentajeCorrectas =
      (totalPreguntasCorrectas / totalPreguntas) * 100;
    const nota = porcentajeCorrectas;
    await strapi.entityService.update(
      "api::examen.examen",
      examInformation.id,
      {
        data: {
          Nota: nota,
        },
      }
    );
  },
  async generateSpecificExamenNumberQuestions(ctx) {
    const { selectEspecialidad, selectEspecialidadExtras, type } =
      ctx.request.body;
    let clave = type == 0 ? "sub_especialidades" : "sub_espe_visuals";
    let allEspecialidades = true;
    let idSubEspecialidades = [];
    let numberEspecialidadesPreguntas = 0;
    for (
      let index = 0;
      index < selectEspecialidad.attributes[clave].data.length;
      index++
    ) {
      var element = selectEspecialidad.attributes[clave].data[index];
      if (element.seleccionado == true) {
        allEspecialidades = false;
        idSubEspecialidades.push(element.id);
      }
    }
    if (allEspecialidades) {
      for (
        let index = 0;
        index < selectEspecialidad.attributes[clave].data.length;
        index++
      ) {
        var element = selectEspecialidad.attributes[clave].data[index];
        const resultado = await strapi.entityService.findOne(
          type == 0
            ? "api::sub-especialidad.sub-especialidad"
            : "api::sub-espe-visual.sub-espe-visual",
          element.id,
          {
            populate:
              type == 0
                ? // @ts-ignore
                  { preguntas_especialidads: true }
                : { preguntas_visuals: true },
          }
        );
        numberEspecialidadesPreguntas +=
          resultado[type == 0 ? "preguntas_especialidads" : "preguntas_visuals"]
            .length;
      }
    } else {
      for (let index = 0; index < idSubEspecialidades.length; index++) {
        var element = idSubEspecialidades[index];
        const resultado = await strapi.entityService.findOne(
          type == 0
            ? "api::sub-especialidad.sub-especialidad"
            : "api::sub-espe-visual.sub-espe-visual",
          element,
          {
            populate:
              type == 0
                ? // @ts-ignore
                  { preguntas_especialidads: true }
                : { preguntas_visuals: true },
          }
        );
        numberEspecialidadesPreguntas +=
          resultado[type == 0 ? "preguntas_especialidads" : "preguntas_visuals"]
            .length;
      }
    }
    let idsSubsExternals = [];
    for (let index = 0; index < selectEspecialidadExtras.length; index++) {
      var element = selectEspecialidadExtras[index];
      for (
        let indexInternal = 0;
        indexInternal < element.attributes[clave].data.length;
        indexInternal++
      ) {
        var elementI = element.attributes[clave].data[indexInternal];
        if (elementI.seleccionado == true) {
          idsSubsExternals.push(elementI.id);
        }
      }
    }
    for (let index = 0; index < idsSubsExternals.length; index++) {
      var element = idsSubsExternals[index];
      const resultado = await strapi.entityService.findOne(
        type == 0
          ? "api::sub-especialidad.sub-especialidad"
          : "api::sub-espe-visual.sub-espe-visual",
        element,
        {
          populate:
            type == 0
              ? // @ts-ignore
                { preguntas_especialidads: true }
              : { preguntas_visuals: true },
        }
      );
      numberEspecialidadesPreguntas +=
        resultado[type == 0 ? "preguntas_especialidads" : "preguntas_visuals"]
          .length;
    }
    return {
      data: numberEspecialidadesPreguntas,
    };
  },
  async mezclarArray(array, cantidad) {
    // Copiamos el array para no modificar el original
    let newArray = array.slice();
    for (let i = newArray.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [newArray[i], newArray[j]] = [newArray[j], newArray[i]]; // Intercambiamos los elementos
    }
    return newArray.slice(0, Math.min(cantidad, newArray.length));
  },
  async generateCompleteExamenSpecificQuestions(ctx) {
    const {
      idUser,
      title,
      selectEspecialidad,
      selectEspecialidadExtras,
      type,
      numberQuestions,
    } = ctx.request.body;
    const fechaActual = moment();
    fechaActual.locale("es");
    const fechaFormateada = fechaActual.format("LL"); // 'LL' representa el formato de fecha en español
    let clave = type == 0 ? "sub_especialidades" : "sub_espe_visuals";
    let allEspecialidades = true;
    let idSubEspecialidades = [];
    let idsListExamQuestions = [];
    for (
      let index = 0;
      index < selectEspecialidad.attributes[clave].data.length;
      index++
    ) {
      var element = selectEspecialidad.attributes[clave].data[index];
      if (element.seleccionado == true) {
        allEspecialidades = false;
        idSubEspecialidades.push(element.id);
      }
    }
    if (allEspecialidades) {
      for (
        let index = 0;
        index < selectEspecialidad.attributes[clave].data.length;
        index++
      ) {
        var element = selectEspecialidad.attributes[clave].data[index];
        const resultado = await strapi.entityService.findOne(
          type == 0
            ? "api::sub-especialidad.sub-especialidad"
            : "api::sub-espe-visual.sub-espe-visual",
          element.id,
          {
            populate:
              type == 0
                ? // @ts-ignore
                  { preguntas_especialidads: true }
                : { preguntas_visuals: true },
          }
        );
        for (
          let indexIntQuestion = 0;
          indexIntQuestion <
          resultado[type == 0 ? "preguntas_especialidads" : "preguntas_visuals"]
            .length;
          indexIntQuestion++
        ) {
          const element =
            resultado[
              type == 0 ? "preguntas_especialidads" : "preguntas_visuals"
            ][indexIntQuestion];
          const normalQuestions = await strapi.entityService.findOne(
            type == 0
              ? "api::pregunta.pregunta"
              : "api::preguntas-visual.preguntas-visual",
            element.id,
            {
              populate:
                type == 0
                  ? {
                      sub_especialidade: true,
                      flash_card: true,
                      Imagen: true,
                    }
                  : { sub_espe_visual: true, flash_card: true, Imagen: true },
            }
          );

          const entry = await strapi.entityService.create(
            "api::pregunta-examen.pregunta-examen",
            {
              data: {
                pregunta: JSON.stringify({
                  identificator: type == 0 ? "especialidad" : "visual",
                  elemento: normalQuestions,
                }),
              },
            }
          );
          idsListExamQuestions.push(entry.id);
        }
      }
    } else {
      for (let index = 0; index < idSubEspecialidades.length; index++) {
        var element = idSubEspecialidades[index];
        const resultado = await strapi.entityService.findOne(
          type == 0
            ? "api::sub-especialidad.sub-especialidad"
            : "api::sub-espe-visual.sub-espe-visual",
          element,
          {
            populate:
              type == 0
                ? // @ts-ignore
                  { preguntas_especialidads: true }
                : { preguntas_visuals: true },
          }
        );
        for (
          let indexIntQuestion = 0;
          indexIntQuestion <
          resultado[type == 0 ? "preguntas_especialidads" : "preguntas_visuals"]
            .length;
          indexIntQuestion++
        ) {
          const element =
            resultado[
              type == 0 ? "preguntas_especialidads" : "preguntas_visuals"
            ][indexIntQuestion];
          const normalQuestions = await strapi.entityService.findOne(
            type == 0
              ? "api::pregunta.pregunta"
              : "api::preguntas-visual.preguntas-visual",
            element.id,
            {
              populate:
                type == 0
                  ? {
                      sub_especialidade: true,
                      flash_card: true,
                      Imagen: true,
                    }
                  : { sub_espe_visual: true, flash_card: true, Imagen: true },
            }
          );

          const entry = await strapi.entityService.create(
            "api::pregunta-examen.pregunta-examen",
            {
              data: {
                pregunta: JSON.stringify({
                  identificator: type == 0 ? "especialidad" : "visual",
                  elemento: normalQuestions,
                }),
              },
            }
          );
          idsListExamQuestions.push(entry.id);
        }
      }
    }
    let idsSubsExternals = [];
    for (let index = 0; index < selectEspecialidadExtras.length; index++) {
      var element = selectEspecialidadExtras[index];
      for (
        let indexInternal = 0;
        indexInternal < element.attributes[clave].data.length;
        indexInternal++
      ) {
        var elementI = element.attributes[clave].data[indexInternal];
        if (elementI.seleccionado == true) {
          idsSubsExternals.push(elementI.id);
        }
      }
    }
    for (let index = 0; index < idsSubsExternals.length; index++) {
      var element = idsSubsExternals[index];
      const resultado = await strapi.entityService.findOne(
        type == 0
          ? "api::sub-especialidad.sub-especialidad"
          : "api::sub-espe-visual.sub-espe-visual",
        element,
        {
          populate:
            type == 0
              ? // @ts-ignore
                { preguntas_especialidads: true }
              : { preguntas_visuals: true },
        }
      );
      for (
        let indexIntQuestion = 0;
        indexIntQuestion <
        resultado[type == 0 ? "preguntas_especialidads" : "preguntas_visuals"]
          .length;
        indexIntQuestion++
      ) {
        const element =
          resultado[
            type == 0 ? "preguntas_especialidads" : "preguntas_visuals"
          ][indexIntQuestion];
        const normalQuestions = await strapi.entityService.findOne(
          type == 0
            ? "api::pregunta.pregunta"
            : "api::preguntas-visual.preguntas-visual",
          element.id,
          {
            populate:
              type == 0
                ? {
                    sub_especialidade: true,
                    flash_card: true,
                    Imagen: true,
                  }
                : { sub_espe_visual: true, flash_card: true, Imagen: true },
          }
        );

        const entry = await strapi.entityService.create(
          "api::pregunta-examen.pregunta-examen",
          {
            data: {
              pregunta: JSON.stringify({
                identificator: type == 0 ? "especialidad" : "visual",
                elemento: normalQuestions,
              }),
            },
          }
        );
        idsListExamQuestions.push(entry.id);
      }
    }
    var listShuffle = await this.mezclarArray(
      idsListExamQuestions,
      numberQuestions
    );

    const createExam = await strapi.entityService.create("api::examen.examen", {
      data: {
        preguntas_examen: listShuffle,
        users_permissions_user: idUser,
        Fecha: fechaFormateada,
        Titulo: title,
      },
    });

    return {
      data: createExam.id,
    };
  },
}));
