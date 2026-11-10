SELECT * FROM Parfum ;
SELECT * FROM Commande ;
SELECT * FROM Produit ;
SELECT * FROM Client ;
SELECT COUNT(*) FROM Client ;

SHOW CREATE TABLE Commande;

/* prix negatif % */
UPDATE Produit SET prix_produit = -5 WHERE reference_produit = (SELECT reference_produit FROM (SELECT reference_produit FROM Produit LIMIT 1) t);

/* remise de 150 % */
UPDATE Promotion SET remise_promotion = 150 LIMIT 1;

/* statut invalide */
UPDATE Commande SET statut_commande = 'perdu' LIMIT 1;

/* email invalide */
UPDATE Client SET email_client = 'pas-un-email' LIMIT 1;

INSERT INTO Parfum
SELECT 99, 'Test', 'Floral', 2026, 20, 'Paul Guerlain' FROM Parfum LIMIT 1;  

/* affiche le parfum dont id=99 */
SELECT nom_parfums FROM Parfum
WHERE id_parfum = 99;

/* Modification de sa clé primaire */
UPDATE Parfum SET nom_parfums = "Exclusif"  WHERE id_parfum = 99 ;

/* Suppression d'un parfum non reference */
DELETE FROM Parfum WHERE id_parfum = 99;

/* Suppression d'un parfum référencé par clee etrangere */
DELETE FROM Parfum WHERE id_parfum = 1;