CREATE TABLE dbo.Seanslar (
    SeansID INT IDENTITY(1,1) PRIMARY KEY,
    FilmID INT NOT NULL,
    SalonID INT NOT NULL,
    Tarih DATE NOT NULL,
    Saat TIME NOT NULL,
    BaseFiyat DECIMAL(6,2) NOT NULL
);
ALTER TABLE dbo.Seanslar
ADD CONSTRAINT FK_Seanslar_Film FOREIGN KEY (FilmID) REFERENCES dbo.film(FilmID);
INSERT INTO dbo.Seanslar (FilmID, SalonID, Tarih, Saat, BaseFiyat) VALUES
(1, 1, '2025-08-25', '14:00', 50.00),
(1, 2, '2025-08-25', '18:00', 55.00),
(2, 1, '2025-08-26', '16:00', 60.00),
(2, 3, '2025-08-26', '20:00', 65.00),
(3, 2, '2025-08-27', '15:00', 50.00),
(3, 3, '2025-08-27', '19:00', 55.00),
(4, 1, '2025-08-28', '14:30', 60.00),
(4, 2, '2025-08-28', '18:30', 65.00),
(5, 3, '2025-08-29', '17:00', 55.00),
(5, 1, '2025-08-29', '21:00', 60.00);

CREATE TABLE dbo.Biletler (
    BiletID INT IDENTITY(1,1) PRIMARY KEY,
    SeansID INT NOT NULL,
    MusteriID INT NOT NULL,
    KoltukNo NVARCHAR(10) NOT NULL,
    Fiyat DECIMAL(6,2) NOT NULL,
    SatilmaTarihi DATETIME NOT NULL DEFAULT GETDATE()
);
ALTER TABLE dbo.Biletler
ADD CONSTRAINT FK_Biletler_Seanslar
FOREIGN KEY (SeansID) REFERENCES dbo.Seanslar(SeansID);

ALTER TABLE dbo.Biletler
ADD CONSTRAINT FK_Biletler_Musteriler
FOREIGN KEY (MusteriID) REFERENCES dbo.musteri(MusteriID);

INSERT INTO dbo.Biletler (SeansID, MusteriID, KoltukNo, Fiyat)
VALUES
(1, 1, 'A1', 50.00),
(1, 2, 'A2', 50.00),
(1, 3, 'A3', 50.00),
(2, 4, 'B1', 55.00),
(2, 5, 'B2', 55.00),
(2, 6, 'B3', 55.00),
(3, 7, 'C1', 60.00),
(3, 8, 'C2', 60.00),
(3, 9, 'C3', 60.00),
(4, 10, 'D1', 65.00),
(4, 11, 'D2', 65.00),
(4, 12, 'D3', 65.00),
(5, 13, 'E1', 55.00),
(5, 14, 'E2', 55.00),
(5, 15, 'E3', 55.00),
(1, 16, 'A4', 50.00),
(1, 17, 'A5', 50.00),
(2, 18, 'B4', 55.00),
(2, 19, 'B5', 55.00),
(3, 20, 'C4', 60.00),
(3, 21, 'C5', 60.00),
(4, 22, 'D4', 65.00),
(4, 23, 'D5', 65.00),
(5, 24, 'E4', 55.00),
(5, 25, 'E5', 55.00),
(1, 26, 'A6', 50.00),
(1, 27, 'A7', 50.00),
(2, 28, 'B6', 55.00),
(2, 29, 'B7', 55.00),
(3, 30, 'C6', 60.00),
(3, 31, 'C7', 60.00),
(4, 32, 'D6', 65.00),
(4, 33, 'D7', 65.00),
(5, 34, 'E6', 55.00),
(5, 35, 'E7', 55.00),
(1, 36, 'A8', 50.00),
(1, 37, 'A9', 50.00),
(2, 38, 'B8', 55.00),
(2, 39, 'B9', 55.00),
(3, 40, 'C8', 60.00),
(3, 41, 'C9', 60.00),
(4, 42, 'D8', 65.00),
(4, 43, 'D9', 65.00),
(5, 44, 'E8', 55.00),
(5, 45, 'E9', 55.00),
(1, 46, 'A10', 50.00),
(1, 47, 'A11', 50.00),
(2, 48, 'B10', 55.00),
(2, 49, 'B11', 55.00),
(6, 50, 'C10', 60.00);

--HER SEANSIN SATILAN BÝLET SAYISI
SELECT 
    s.SeansID,
    f.Tür AS FilmAdi,
    s.Tarih,
    s.Saat,
    COUNT(b.BiletID) AS SatilanBiletSayisi
FROM dbo.Seanslar s
JOIN dbo.Film f ON s.FilmID = f.FilmID
LEFT JOIN dbo.Biletler b ON s.SeansID = b.SeansID
GROUP BY s.SeansID, f.Tür, s.Tarih, s.Saat
ORDER BY s.Tarih, s.Saat;


--HANGÝ MÜÞTERÝ KAÇ BÝLET ALDI
--TOPLAM HARCAMA BULMA
SELECT 
    m.MusteriID,
    m.AdSoyad AS MusteriAdi,
    COUNT(b.BiletID) AS ToplamBilet,
    SUM(b.Fiyat) AS ToplamHarcama
FROM dbo.musteri m
LEFT JOIN dbo.Biletler b ON m.MusteriID = b.MusteriID
GROUP BY m.MusteriID, m.AdSoyad
ORDER BY ToplamHarcama DESC;

--FÝLMLERÝN TOPLAM SATIÞ GELÝRLERÝ
SELECT 
	f.FilmID,
	f.Ad AS FilmAdi,
	COUNT(b.BiletID) AS ToplamBilet,
	SUM(b.Fiyat) AS ToplamHarcama
FROM dbo.film f
LEFT JOIN dbo.Seanslar s ON f.FilmID = s.FilmID
LEFT JOIN dbo.Biletler b ON s.SeansID = b.SeansID
GROUP BY f.FilmID, f.Ad
ORDER BY ToplamHarcama DESC;

--EN ÇOK BÝLET SATAN FÝLM
SELECT 
	f.Ad AS FilmAdi,
	COUNT(b.BiletID) AS ToplamBilet -- o film için satýlan bilet sayýsý 
FROM dbo.Film f
JOIN dbo.Seanslar s ON f.FilmID = s.FilmID  -- Film ile seanslarý baðladýk
LEFT JOIN dbo.Biletler b ON s.SeansID = b.SeansID -- Seans ile biletleri baðladýk
GROUP BY f.Ad                          
ORDER BY ToplamBilet DESC;

--50 TL OLAN BÝLETLERÝ LÝSTELEMEK
SELECT BiletID, SeansID, MusteriID, Fiyat FROM dbo.Biletler WHERE Fiyat = 50.00

--50TL ÝLE 60 TL ARASINDA OLANLAR
SELECT 
    BiletID,
    SeansID,
    MusteriID,
    Fiyat
FROM dbo.Biletler
WHERE Fiyat BETWEEN 50.00 AND 60.00;

-- ADI A HARFÝ ÝLE BAÞLAYAN YÖNETMENLER
SELECT *
FROM dbo.Yonetmen
WHERE AdSoyad LIKE 'A%';

--HER YÖNETMENÝN KAÇ FÝLMÝ OLDUÐUNU BULMAK
SELECT 
    y.AdSoyad AS YonetmenAdi,
    COUNT(f.FilmID) AS FilmSayisi
FROM dbo.Yonetmen y
LEFT JOIN dbo.fy ON y.YonetmenID = fy.YonetmenID
LEFT JOIN dbo.Film f ON fy.FilmID = f.FilmID
GROUP BY y.AdSoyad
ORDER BY FilmSayisi DESC;

--EN ÇOK ÝZLENEN YÖNETMEN
SELECT 
	y.AdSoyad AS YonetmenAdi,
	COUNT(b.BiletID) AS SatilanBiletSayisi
FROM dbo.Yonetmen y
JOIN dbo.fy ON y.YonetmenID = fy.YonetmenID
JOIN dbo.Film f ON fy.FilmID = f.FilmID
JOIN dbo.Seanslar s ON f.FilmID = s.FilmID
JOIN dbo.Biletler b ON s.SeansID = b.SeansID
GROUP BY y.AdSoyad
ORDER BY SatilanBiletSayisi DESC;

--EN UZUN SÜRELÝ FÝLM VE SÜRESÝNÝ BULMA
SELECT TOP 1 
	Ad AS FilmAdi,
	Süre_dk AS Dakika
FROM dbo.film
Order By Süre_dk DESC

--TRIGGER
--Satýlan koltuk iki kere satýlamasýn
CREATE TRIGGER trg_BiletKontrol
ON dbo.Biletler
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM dbo.Biletler b
        JOIN inserted i ON b.SeansID = i.SeansID AND b.KoltukNo = i.KoltukNo
        GROUP BY b.SeansID, b.KoltukNo
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR('Bu koltuk zaten satýlmýþ!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
--kontrol edelim...
INSERT INTO dbo.Biletler (SeansID, MusteriID, KoltukNo, Fiyat)
VALUES (1, 5, 'A1', 50.00);

--FONKSÝYON
--toplam gelir bulma
CREATE FUNCTION dbo.FilmToplamGelir(@FilmID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
	DECLARE @Toplam DECIMAL(10,2)
	
	SELECT @Toplam = SUM(b.Fiyat)
	FROM dbo.Biletler b
	INNER JOIN dbo.Seanslar s ON b.SeansID = s.SeansID
	WHERE s.FilmID = @FilmID;

	RETURN ISNULL(@Toplam, 0); 
END;

--çalýþtýralým...
SELECT dbo.FilmToplamGelir(1) AS ToplamGelir;

--her seans kaç bilet satmýþ..
SELECT SeansID, COUNT(BiletID) 
AS 
SatilanBilet
From dbo.Biletler
GROUP BY 
SeansID












