--
-- エコカー減税100% (ID:37)
--
-- 判定方法: preferentialTaxTypeFlg が 1
-- 最終更新: 2014-01-31
--

--
-- 標準 2WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  37,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.preferentialTaxTypeFlg = 1
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
  37,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.preferentialTaxTypeFlg = 1
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s4wdCarGradeID = G.carGradeID;
