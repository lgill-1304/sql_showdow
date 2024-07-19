/*1 consulta de DisplayName, Loaction y Reputation filtrado con mayor reputacion, limitando filas, orden descendente*/
SELECT TOP 10 DisplayName, Location, Reputation
FROM Users
ORDER BY Reputation DESC;

/*2 consulta dond mostramos los resultados de Title y DisplayName */
SELECT TOP 10 Posts.Title, Users.DisplayName
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id
WHERE Posts.OwnerUserId IS NOT NULL;

/*3 consulta promedio de puntos(score) de cada usuario Junto con DisplayName*/
SELECT TOP 10 U.DisplayName, AVG(P.Score) AS AverageScore
FROM Posts P
INNER JOIN Users U ON P.OwnerUserId = U.Id
GROUP BY U.DisplayName
ORDER BY AverageScore DESC;

/*4 consulta DisplayName de usuarios que han realizado 100 comentarios*/
SELECT TOP 200
DisplayName
FROM Users
WHERE Id IN (
		SELECT UserId
		FROM Comments
		GROUP BY UserId
		HAVING COUNT (*) > 100
);

/*5 consulta actualizar la columna location de user, pasan de vacias a desconocido*/
UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = '';

 /*Consulta para seleccionar los primeros 200 registros actualizados*/
SELECT TOP 200 Id, DisplayName, Location
FROM Users 
WHERE Location = 'Desconocido';

--Mensaje de confirmacion--
PRINT 'Actualizacion realizada correctamente';

SELECT TOP 200 * FROM Posts;

/*6 consulta todos los comentarios realizados por usuarios con menos de 100 de reputación eliminados*/
DELETE Comments
FROM Comments
JOIN Users ON Comments.UserId = Users.Id
WHERE Users.Reputation < 100;

/*Muestra mensaje de confirmacion con numero de filas eliminadas*/
PRINT 'Numero de comentrios eliminados: ' + CAST (@@ROWCOUNT AS NVARCHAR(10));

/*7 consulta muestra el total de publicaciones, post, comentarios y medallas*/
SELECT TOP 200
		Users.DisplayName,
		(SELECT COUNT (*) FROM Posts WHERE OwnerUserId = Users.Id) As TotalPosts,
		(SELECT COUNT (*) FROM Comments WHERE UserId = Users.Id) As TotalComments,
		(SELECT COUNT (*) FROM Badges WHERE UserId = Users.Id) As TotalBadges

FROM
		Users
ORDER BY 
		TotalPosts DESC, Users.DisplayName;

/*8 Muestra las 10 publicaciones más populares basadas en la puntuación*/
SELECT TOP 10 Title, Score
FROM Posts
WHERE Title IS NOT NULL
ORDER BY Score DESC; 

/*9 Muestra los 5 comentarios más recientes de la tabla*/
SELECT TOP 5 Text, CreationDate
FROM Comments
ORDER BY CreationDate DESC;
