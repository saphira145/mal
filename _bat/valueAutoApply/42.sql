--
-- 電気自動車 (ID: 42)
--
-- 判定方法: useFuel が「電気」
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
  42,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.useFuel = '電気'
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
  42,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.useFuel = '電気'
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s4wdCarGradeID = G.carGradeID;
