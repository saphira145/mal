--
-- 燃費がいい (ID: 39)
--
-- 選定の目安: 上位 20% 以上
-- 現在のしきい値: 23km/l 以上
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
  39,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.fuelConsumptionRateJC08mode >= 23
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s2wdCarGradeID = G.carGradeID
ORDER BY
  CAST(G.fuelConsumptionRateJC08mode AS DECIMAL(6,2)) DESC;
--
-- 標準 4WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  39,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.fuelConsumptionRateJC08mode >= 23
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s4wdCarGradeID = G.carGradeID
ORDER BY
  CAST(G.fuelConsumptionRateJC08mode AS DECIMAL(6,2)) DESC;
