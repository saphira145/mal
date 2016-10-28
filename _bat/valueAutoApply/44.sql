--
-- 役員車に向いている (ID:44) 仮
--
-- 条件: セダン + 排気量 2000cc 以上
-- 最終更新: 2014-02-10
--
-- 旧条件 (2014-02-03): セダン + 排気量 3000cc 以上 + 価格500万円以上
--  G.bodyModelName = 'セダン'
--  AND G.totalEmission >= 3000
--  AND G.price >= 500
--

--
-- 標準 2WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  44,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.bodyModelName = 'セダン'
  AND G.totalEmission >= 2000
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s2wdCarGradeID = G.carGradeID;
--
-- 標準 4WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  44,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.bodyModelName = 'セダン'
  AND G.totalEmission >= 2000
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s4wdCarGradeID = G.carGradeID;
