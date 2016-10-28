--
-- ハイブリッド車 (ID: 41)
--
-- 判定方法:
--   engineKind が空または - でない、
--   かつ motorKind が空または - でない
-- 最終更新: 2014-02-03
--

--
-- 標準 2WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  41,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.engineKind <> ''
  AND G.engineKind <> '-'
  AND G.motorKind <> ''
  AND G.motorKind <> '-'
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
  41,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.engineKind <> ''
  AND G.engineKind <> '-'
  AND G.motorKind <> ''
  AND G.motorKind <> '-'
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s4wdCarGradeID = G.carGradeID;
