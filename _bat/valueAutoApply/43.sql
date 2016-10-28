--
-- 盗難防止装置がついている (ID: 43)
--
-- 条件: エンジンイモビライザーが標準装備
-- 判定方法: seatCircumference.engineImmobilizerType が 2
-- 最終更新: 2014-02-03
--
-- 各種「有無フラグ」
-- 1 ... － (記載なし)
-- 2 ... ○ (あり)
-- 3 ... ×
-- 4 ... Ｍ (メーカーオプションあり)
-- 5 ... Ｄ (ディーラーオプションあり)
--

--
-- 標準 2WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  43,
  now(),
  0
FROM
  model AS M,
  carGrade AS G,
  seatCircumference AS S
WHERE
  S.engineImmobilizerType = 2
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s2wdCarGradeID = G.carGradeID
  AND G.carGradeID = S.carGradeID;
--
-- 標準 4WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  43,
  now(),
  0
FROM
  model AS M,
  carGrade AS G,
  seatCircumference AS S
WHERE
  S.engineImmobilizerType = 2
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s4wdCarGradeID = G.carGradeID
  AND G.carGradeID = S.carGradeID;
