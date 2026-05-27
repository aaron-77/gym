-- Fix urlParaParaDescripcionDeClase for classes with non-existent images
-- HIIT (5) and Yoga (12) already correct, skip them

UPDATE imagesForClases SET urlParaParaDescripcionDeClase = N'/img/crossfit.jpg',           FechaDeModificacion = GETDATE() WHERE fkClase = 6;
UPDATE imagesForClases SET urlParaParaDescripcionDeClase = N'/img/strengthherosection.jpg', FechaDeModificacion = GETDATE() WHERE fkClase = 7;
UPDATE imagesForClases SET urlParaParaDescripcionDeClase = N'/img/boxing.jpg',              FechaDeModificacion = GETDATE() WHERE fkClase = 8;
UPDATE imagesForClases SET urlParaParaDescripcionDeClase = N'/img/functional.jpg',          FechaDeModificacion = GETDATE() WHERE fkClase = 9;
UPDATE imagesForClases SET urlParaParaDescripcionDeClase = N'/img/personaltraining.jpg',    FechaDeModificacion = GETDATE() WHERE fkClase = 10;
