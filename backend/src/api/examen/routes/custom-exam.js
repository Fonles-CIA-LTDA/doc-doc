module.exports = {
  routes: [
    {
      method: "POST",
      path: "/generate/exam",
      handler: "examen.generateCompleteExamen",
    },
    {
      method: "POST",
      path: "/qualify/exam",
      handler: "examen.qualifyExam",
    },
    {
      method: "POST",
      path: "/qualify/user",
      handler: "examen.generateQualifyExamByUser",
    },
    {
      method: "POST",
      path: "/generate/specific/exam",
      handler: "examen.generateSpecificExamenNumberQuestions",
    },
    {
      method: "POST",
      path: "/generate/specific/exam/final",
      handler: "examen.generateCompleteExamenSpecificQuestions",
    },
    {
      method: "GET",
      path: "/qualify/top",
      handler: "examen.generateQualifyExamTop",
    },
  ],
};
