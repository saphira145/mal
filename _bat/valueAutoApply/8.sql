--
-- 安全性が高い (ID:8)
--
-- 選定の目安: 衝突安全ボディ採用 + ABS 標準装備 + 運転席にエアバッグ標準装備 + 助手席にエアバッグ標準装備
-- 最終更新: 2014-02-07
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
  8,
  now(),
  0
FROM
  model AS M,
  carGrade AS G,
  safety AS S
WHERE
  safetyStructureBodyType = 2
  AND ABSType = 2
  AND driverSeatSRSAirBackSystemType = 2
  AND passengerSeatSRSAirBackSystemType = 2
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
  8,
  now(),
  0
FROM
  model AS M,
  carGrade AS G,
  safety AS S
WHERE
  safetyStructureBodyType = 2
  AND ABSType = 2
  AND driverSeatSRSAirBackSystemType = 2
  AND passengerSeatSRSAirBackSystemType = 2
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s4wdCarGradeID = G.carGradeID
  AND G.carGradeID = S.carGradeID;
